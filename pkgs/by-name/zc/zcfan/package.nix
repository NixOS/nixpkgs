{ lib
, stdenv
, fetchFromGitHub
}:

# Testing this requires a Thinkpad or the presence of /proc/acpi/ibm/fan
stdenv.mkDerivation (finalAttrs: {
  pname = "zcfan";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "cdown";
    repo = "zcfan";
    rev = finalAttrs.version;
    hash = "sha256-zpYQEHXt8LBNX+luM4YxP0dKH+hb2c8Z0BEeGP09oZo=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "/usr/local" $out
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/${finalAttrs.pname} -h

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A zero-configuration fan daemon for ThinkPads";
    mainProgram = "zcfan";
    homepage = "https://github.com/cdown/zcfan";
    changelog = "https://github.com/cdown/zcfan/tags/${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kashw2 ];
    platforms = platforms.linux;
  };
})
