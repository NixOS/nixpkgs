{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  pkg-config,
  aml,
  json_c,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vali";
  version = "0.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "emersion";
    repo = "vali";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u7tJi3qHT2HEMa+E9RwcvRyrLuBA5o14ID8Kl3xkzHc=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];
  propagatedBuildInputs = [
    json_c
    aml
  ];

  doCheck = true;

  meta = {
    description = "A C library and code generator for Varlink";
    mainProgram = "vali";
    homepage = "https://gitlab.freedesktop.org/emersion/vali";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.macaquinyho ];
    platforms = lib.platforms.linux;
  };
})
