{ stdenv, buildPythonPackage, fetchPypi, pythonPackages }:

buildPythonPackage rec {
  pname = "rfc6555";
  version = "0.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05sjrd6jc0sdvx0z7d3llk82rx366jlmc7ijam0nalsv66hbn70r";
  };

  propagatedBuildInputs = with pythonPackages; [ selectors2 ];

  # tests are disabled as rfc6555's 'non-network' tests still require a
  # functional DNS stack to pass.
  doCheck = false;

  meta = {
    description = "Python implementation of the Happy Eyeballs Algorithm";
    homepage = "https://pypi.org/project/rfc6555";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ endocrimes ];
  };
}
