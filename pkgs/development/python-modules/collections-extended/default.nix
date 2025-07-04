{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "collections-extended";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlenzen";
    repo = "collections-extended";
    tag = "v${version}";
    hash = "sha256-cK13+CQUELKSiLpG747+C+RB5b6luu0mWLLXTT+uGH4=";
  };

  # shuffle's random option has been removed in python 3.11
  postPatch = ''
    substituteInPlace collections_extended/setlists.py \
      --replace-fail \
        "random_.shuffle(self._list, random=random)" \
        "random_.shuffle(self._list)"
  '';

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "collections_extended" ];

  meta = {
    description = "Extra Python Collections - bags (multisets), setlists (unique list/indexed set), RangeMap and IndexedDict";
    homepage = "https://github.com/mlenzen/collections-extended";
    changelog = "https://github.com/mlenzen/collections-extended/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ exarkun ];
  };
}
