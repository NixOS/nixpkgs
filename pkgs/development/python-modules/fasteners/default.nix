{ stdenv
, buildPythonPackage
, fetchPypi
, six
, monotonic
, futures
, testtools
, isPy3k
}:

buildPythonPackage rec {
  pname = "fasteners";
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "427c76773fe036ddfa41e57d89086ea03111bbac57c55fc55f3006d027107e18";
  };

  checkInputs = [ testtools ] ++ stdenv.lib.optionals (!isPy3k) [ futures ];
  propagatedBuildInputs = [ six monotonic ];

  meta = with stdenv.lib; {
    description = "A python package that provides useful locks";
    homepage = https://github.com/harlowja/fasteners;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
