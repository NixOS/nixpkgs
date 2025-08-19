{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  re,
}:

buildDunePackage rec {
  pname = "duppy";
  version = "0.9.5";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-duppy";
    rev = "v${version}";
    sha256 = "sha256-hWR7utYMxMjz8Cw0j6cgoHlUj4Jc7Q4vJHD5kGHN4Rc=";
  };

  propagatedBuildInputs = [ re ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-duppy";
    description = "Library providing monadic threads";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
