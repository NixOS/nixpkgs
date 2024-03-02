{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# tests
, pytestCheckHook
, pexpect
}:

buildPythonPackage rec {
  pname = "readchar";
  version = "4.0.5";
  pyproject = true;

  # Don't use wheels on PyPI
  src = fetchFromGitHub {
    owner = "magmax";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ru18lh+9tXtvttypnob0HNPKBiGF7E9HDL21l1AAGa8=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=readchar" "" \
      --replace "attr: readchar.__version__" "${version}"
    # run Linux tests on Darwin as well
    # see https://github.com/magmax/python-readchar/pull/99 for why this is not upstreamed
    substituteInPlace tests/linux/conftest.py \
      --replace 'sys.platform.startswith("linux")' 'sys.platform.startswith(("darwin", "linux"))'
  '';

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [ "readchar" ];

  nativeCheckInputs = [
    pytestCheckHook
    pexpect
  ];

  meta = with lib; {
    homepage = "https://github.com/magmax/python-readchar";
    description = "Python library to read characters and key strokes";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
  };
}
