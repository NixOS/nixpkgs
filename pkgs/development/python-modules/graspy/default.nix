{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, pytest
, pytestcov
, matplotlib
, networkx
, numpy
, scikitlearn
, scipy
, seaborn
}:

buildPythonPackage rec {
  pname = "graspy";
  version = "0.2";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "neurodata";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ss7d71lwblimg7ri88ir9w59j0ri13wl75091hjf7q0mchqr6yd";
  };

  propagatedBuildInputs = [
    matplotlib
    networkx
    numpy
    scikitlearn
    scipy
    seaborn
  ];

  checkInputs = [ pytest pytestcov ];

  checkPhase = ''
    runHook preCheck
    # `test_autogmm` takes too long; fixed in next release (graspy/pull/328)
    pytest tests -k 'not test_autogmm'
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://graspy.neurodata.io";
    description = "A package for graph statistical algorithms";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
