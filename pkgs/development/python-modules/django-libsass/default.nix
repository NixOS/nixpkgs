{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  django-compressor,
  libsass,

  # tests
  django,
  python,
}:

buildPythonPackage rec {
  pname = "django-libsass";
  version = "0.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "torchbox";
    repo = "django-libsass";
    tag = "v${version}";
    hash = "sha256-54AlRVmit0rtG1jx7O+XyA1vXLHCfoNPjHkHCQaaybA=";
  };

  propagatedBuildInputs = [
    django-compressor
    libsass
  ];

  nativeCheckInputs = [ django ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} ./runtests.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Django-compressor filter to compile SASS files using libsass";
    homepage = "https://github.com/torchbox/django-libsass";
    changelog = "https://github.com/torchbox/django-libsass/blob/${src.rev}/CHANGELOG.txt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
