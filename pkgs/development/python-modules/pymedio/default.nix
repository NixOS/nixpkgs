{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, numpy
}:

buildPythonPackage rec {
  pname = "pymedio";
  version = "0.2.13";
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jcreinhold";
    repo = "pymedio";
    rev = "refs/tags/v${version}";
    hash = "sha256-iHbClOrtYkHT1Nar+5j/ig4Krya8LdQdFB4Mmm5B9bg=";
  };

  # relax Python dep to work with 3.10.x
  postPatch = ''
    substituteInPlace setup.cfg --replace "!=3.10.*," ""
  '';

  propagatedBuildInputs = [ numpy ];

  doCheck = false;  # requires SimpleITK python package (not in Nixpkgs)

  pythonImportsCheck = [
    "pymedio"
  ];

  meta = with lib; {
    description = "Read medical image files into Numpy arrays";
    homepage = "https://github.com/jcreinhold/pymedio";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
