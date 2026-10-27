{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pytestCheckHook,
  python-dateutil,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-crontab";
  version = "3.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "doctormo";
    repo = "python-crontab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MVQNZDCEsX8cjDQQviTfwOarul8+CkdCvWfJMc5Sbq0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "= '3.3.0'," "= '${finalAttrs.version}',"
  '';

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "crontab" ];

  meta = {
    description = "Python API for crontab";
    longDescription = ''
      Crontab module for reading and writing crontab files
      and accessing the system cron automatically and simply using a direct API.
    '';
    homepage = "https://gitlab.com/doctormo/python-crontab/";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [
      fab
      kfollesdal
    ];
  };
})
