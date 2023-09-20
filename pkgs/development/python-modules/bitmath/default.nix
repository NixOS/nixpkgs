{ lib, buildPythonPackage, fetchPypi, isPy3k, progressbar231 ? null, progressbar33, mock }:

buildPythonPackage rec {
  pname = "bitmath";
  version = "1.3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "293325f01e65defe966853111df11d39215eb705a967cb115851da8c4cfa3eb8";
  };

  nativeCheckInputs = [ (if isPy3k then progressbar33 else progressbar231) mock ];

  meta = with lib; {
    description = "Module for representing and manipulating file sizes with different prefix";
    homepage = "https://github.com/tbielawa/bitmath";
    license = licenses.mit;
    maintainers = with maintainers; [ twey ];
  };
}
