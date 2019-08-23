{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "pylev";
  version = "1.3.0";

  # No tests in PyPi tarball
  src = fetchFromGitHub {
    owner = "toastdriven";
    repo = "pylev";
    # Can't use a tag because it's missing
    # https://github.com/toastdriven/pylev/issues/10
    # rev = "v${version};
    rev = "72e3d490515c3188e2acac9c15ea1b466f9ff938";
    sha256 = "18dg1rfnqgfl6x4vafiq4la9d7f65xak19gcvngslq0bm1z6hyd8";
  };

  meta = with lib; {
    homepage = https://github.com/toastdriven/pylev;
    description = "A pure Python Levenshtein implementation that's not freaking GPL'd";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
