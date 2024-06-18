{
  lib,
  stdenv,
  fetchFromGitHub,
  python,
  pyusb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "py3buddy";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "armijnhemel";
    repo = "py3buddy";
    rev = finalAttrs.version;
    hash = "sha256-KJ0xGEXHY6o2074WFZ0u7gATS+wrrjyzanYretckWYk=";
  };

  propagatedBuildInputs = [ pyusb ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D py3buddy.py $out/${python.sitePackages}/py3buddy.py

    runHook postInstall
  '';

  postInstall = ''
    install -D 99-ibuddy.rules $out/lib/udev/rules.d/99-ibuddy.rules
  '';

  meta = {
    description = "Code to work with the iBuddy MSN figurine";
    homepage = "https://github.com/armijnhemel/py3buddy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
  };
})
