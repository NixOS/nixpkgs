{ stdenv
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "retrying";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fwp86xv0rvkncjdvy2mwcvbglw4w9k0fva25i7zx8kd19b3kh08";
  };

  propagatedBuildInputs = [ six ];

  # doesn't ship tests in tarball
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/rholder/retrying;
    description = "General-purpose retrying library";
    license = licenses.asl20;
  };

}
