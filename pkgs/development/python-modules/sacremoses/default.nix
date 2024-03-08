{ buildPythonPackage
, lib
, fetchFromGitHub
, click
, six
, tqdm
, joblib
, pytest
}:

buildPythonPackage rec {
  pname = "sacremoses";
  version = "0.0.35";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alvations";
    repo = pname;
    rev = version;
    sha256 = "1gzr56w8yx82mn08wax5m0xyg15ym4ri5l80gmagp8r53443j770";
  };

  propagatedBuildInputs = [ click six tqdm joblib ];

  nativeCheckInputs = [ pytest ];
  # ignore tests which call to remote host
  checkPhase = ''
    pytest -k 'not truecase'
  '';

  meta = with lib; {
    homepage = "https://github.com/alvations/sacremoses";
    description = "Python port of Moses tokenizer, truecaser and normalizer";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pashashocky ];
  };
}
