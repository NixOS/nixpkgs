{ buildPythonPackage
, cffi
, fetchPypi
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "reflink";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ySU1gtskQTv9cDq/wbKkneePMbSQcjnyhumhkpoebjo=";
  };

  propagatedBuildInputs = [ cffi ];

  propagatedNativeBuildInputs = [ cffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  # FIXME: These do not work, and I have been unable to figure out why.
  doCheck = false;

  pythonImportsCheck = [ "reflink" ];

  meta = with lib; {
    description = "Python reflink wraps around platform specific reflink implementations";
    homepage = "https://gitlab.com/rubdos/pyreflink";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
