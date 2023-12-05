{ lib, buildPythonPackage, fetchPypi, fetchFromGitHub, python, }:

buildPythonPackage rec {
  pname = "pyasn";
  version = "1.6.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-otVfs+5HlHYJ9QIRylsLrEEahvPJNfuSyksLirfGaP8=";
  };

  datasrc = fetchFromGitHub {
    owner = "hadiasghari";
    repo = "pyasn";
    rev = version;
    hash = "sha256-R7Vi1Mn44Mg3HQLDk9O43MkXXwbLRr/jjVKSHJvgYj0";
  };

  postInstall = ''
    install -dm755 $out/${python.sitePackages}/pyasn/data
    cp $datasrc/data/* $out/${python.sitePackages}/pyasn/data
  '';

  doCheck = false; # Tests require internet connection which wont work

  pythonImportsCheck = [ "pyasn" ];

  meta = with lib; {
    description = "Offline IP address to Autonomous System Number lookup module";
    homepage = "https://github.com/hadiasghari/pyasn";
    license = with licenses; [ bsdOriginal mit ];
    maintainers = with maintainers; [ onny ];
  };
}
