{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  scdoc,
  meson,
  ninja,
  pam,
  dinitSupport ? true,
  dinit,
  runitSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "turnstile";
  version = "0.1.11";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chimera-linux";
    repo = "turnstile";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-94J+w0RHxzw7wS70LcpEzMvgevAqAwl0EtiANUmdRYU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    scdoc
    meson
    ninja
  ];

  buildInputs = [
    scdoc
    pam
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "get_option('prefix'), get_option('sysconfdir'), 'turnstile'" "'/etc', 'turnstile'"
  ''
  + lib.optionalString dinitSupport ''
    substituteInPlace backend/dinit \
      --replace-fail '/usr/bin/dinit-monitor' '${lib.getExe' dinit "dinit-monitor"}'
  '';

  mesonFlags = [
    "-Dlocalstatedir=/var"
    "-Dpam_moddir=${placeholder "out"}/lib/security"
    (lib.mesonEnable "dinit" dinitSupport)
    (lib.mesonEnable "runit" runitSupport)
  ];

  meta = {
    homepage = "https://github.com/chimera-linux/turnstile";
    description = "This program waits for user logins and then runs the associated user-service manager";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ vitrial ];
    mainProgram = "turnstiled";
  };

})
