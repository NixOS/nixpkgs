{ lib, buildPythonPackage, fetchFromGitHub, ninja, boost, meson, pkg-config, nix, isPy3k, python }:

buildPythonPackage rec {
  pname = "pythonix";
  version = "0.1.7";
  format = "other";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "pythonix";
    rev = "v${version}";
    sha256 = "1wxqv3i4bva2qq9mx670bcx0g0irjn68fvk28dwvhay9ndwcspqf";
  };

  disabled = !isPy3k;

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ nix boost ];

  postInstall = ''
    # This is typically set by pipInstallHook/eggInstallHook,
    # so we have to do so manually when using meson
    export PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';

  pythonImportsCheck = [ "nix" ];

  meta = with lib; {
    description = ''
       Eval nix code from python.
    '';
    maintainers = [ ];
    license = licenses.mit;
  };
}
