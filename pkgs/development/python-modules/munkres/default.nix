{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  isPy3k,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "munkres";
  version = "1.1.4";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/ES/PDl52tpLa2M93uuP++g4julAnk1OgxDC2heS2wM=";
  };

  patches = [
    # Fixes test on 32-bit systems.
    # Remove if https://github.com/bmc/munkres/pull/41 is merged.
    (fetchpatch {
      url = "https://github.com/bmc/munkres/commit/380a0d593a0569a761c4a035edaa4414c3b4b31d.patch";
      hash = "sha256-awtkwss9ephsh0hhWutBrZsaaJOKgPjpAgiIjMwcRj0=";
    })
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://software.clapper.org/munkres/";
    description = "Munkres algorithm for the Assignment Problem";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
