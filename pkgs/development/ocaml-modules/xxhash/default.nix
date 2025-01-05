{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  xxHash,
  ctypes,
  ctypes-foreign,
  dune-configurator,
  ppx_expect,
}:

buildDunePackage rec {
  pname = "xxhash";
  version = "0.2";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "314eter";
    repo = "ocaml-xxhash";
    tag = "v${version}";
    hash = "sha256-0+ac5EWV9DCVMT4wOcXC95GVEwsUIZzFn2laSzmK6jE=";
  };

  postPatch = ''
    substituteInPlace stubs/dune --replace-warn 'ctypes))' 'ctypes ctypes.stubs))'
  '';

  buildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    ctypes
    ctypes-foreign
    xxHash
  ];

  doCheck = true;

  checkInputs = [
    ppx_expect
  ];

  meta = {
    homepage = "https://github.com/314eter/ocaml-xxhash";
    description = "Bindings for xxHash, an extremely fast hash algorithm";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ toastal ];
  };
}
