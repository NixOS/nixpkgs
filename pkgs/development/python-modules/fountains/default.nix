{ lib
, buildPythonPackage
, fetchPypi
, bitlist
}:

buildPythonPackage rec {
  pname = "fountains";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6de6bc117c376f40a26e111111d638159a2e8a25cfe32f946db0d779decbb70a";
  };

  propagatedBuildInputs = [
    bitlist
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "bitlist~=0.5.1" "bitlist>=0.5.1"
  '';

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [ "fountains" ];

  meta = with lib; {
    description = "Python library for generating and embedding data for unit testing";
    homepage = "https://github.com/reity/fountains";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
