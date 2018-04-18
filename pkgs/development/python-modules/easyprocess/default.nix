{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "EasyProcess";
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07z6485bjxkmx26mp1p1ww19d10qavw0s006bidzailsvk543qll";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Easy to use python subprocess interface";
    homepage = https://github.com/ponty/EasyProcess;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus ];
  };
}
