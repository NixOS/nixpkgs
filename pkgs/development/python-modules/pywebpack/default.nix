{
  lib,
  python3,
  fetchFromGitHub,
  fetchpatch,
  pynpm,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "pywebpack";
  version = "unstable-2022-06-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inveniosoftware";
    repo = "pywebpack";
    rev = "0ce57fb8445a1697acd74a1dd2902b9de279b48c";
    hash = "sha256-Pl3WCjsk4bJ0cHlMPAwGvaBMh8m/QnMyXsO0wgV+wKg=";
  };

  patches =
    [
      # npm: change deps merging algorithm
      (fetchpatch {
        url = "https://github.com/inveniosoftware/pywebpack/pull/39.patch";
        hash = "sha256-NN6PBeH4CouyB5X4Uj5hftcshKMserE8U6WdZSDY8rE=";
      })
    ];

  nativeBuildInputs = [
    python3.pkgs.babel
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [ pynpm ];

  pythonImportsCheck = [ "pywebpack" ];

  meta = with lib; {
    description = "Webpack integration layer for Python";
    homepage = "https://github.com/inveniosoftware/pywebpack";
    changelog = "https://github.com/inveniosoftware/pywebpack/blob/${src.rev}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thubrecht ];
    mainProgram = "pywebpack";
  };
}
