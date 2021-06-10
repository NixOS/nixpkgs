{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy27
, numpy
, pandas
, scipy
, pandas-datareader
, parameterized
, python
}:

buildPythonPackage rec {
  pname = "empyrical";
  version = "0.5.5";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "quantopian";
    repo = pname;
    rev = version;
    sha256 = "1cjplgh7kqqkav1l42r91h1s575xjv68s8awxyf5749wg1jwkfja";
  };

  # one test is known to fail: https://github.com/quantopian/empyrical/issues/131
  patchPhase = ''
    substituteInPlace empyrical/tests/test_perf_attrib.py --replace \
    "    def test_perf_attrib_simple(self):" \
    '    @unittest.skip("known to fail")
        def test_perf_attrib_simple(self):'
  '';

  propagatedBuildInputs = [ numpy pandas scipy pandas-datareader ];

  checkInputs = [ parameterized ];
  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  meta = with lib; {
    description = "Common financial risk metrics";
    homepage = "https://quantopian.github.io/empyrical/";
    license = licenses.asl20;
    maintainers = with maintainers; [ evax ];
    platforms = platforms.unix;
  };
}
