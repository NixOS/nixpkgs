{ lib, buildPythonPackage, fetchPypi, makeWrapper, pythonOlder
, setuptools
, pysha3
, solc
}:

buildPythonPackage rec {
  pname = "crytic-compile";
  version = "0.1.6";

  disabled = pythonOlder "3.6";

  # No Python tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "32c30a9c4e6d2122fe01b21648127bca949c43402ed5a91c10bf3aa34a53731a";
  };
  
  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ pysha3 setuptools ];

  postFixup = ''
    wrapProgram $out/bin/crytic-compile \
      --prefix PATH : "${lib.makeBinPath [ solc ]}"
  '';

  meta = with lib; {
    description = "Abstraction layer for smart contract build systems";
    longDescription = ''
      Crytic-compile is a library to help smart contract compilation.
      It is used in many Crytic tools, e.g. Slither.
    '';
    homepage = "https://github.com/crytic/crytic-compile";
    license = licenses.agpl3;
    maintainers = with maintainers; [ jerengie ];
  };
}
