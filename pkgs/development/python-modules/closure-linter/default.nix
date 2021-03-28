{ lib
, buildPythonPackage
, fetchgit
, isPy3k
, gflags
}:

/* There is a project called "closure-linter" on PyPI that is the
   same as this, but it does not appear to be owned by Google.
   So we're pulling from Google's GitHub repo instead. */
buildPythonPackage {
  pname = "closure-linter";
  version = "2.3.19";

  /* This project has no Python 3 support, as noted by
     https://github.com/google/closure-linter/issues/81 */
  disabled = isPy3k;

  src = fetchgit {
    url = "https://github.com/google/closure-linter";
    rev = "5c27529075bb88bdc45e73008f496dec8438d658";
    sha256 = "076c7q7pr7akfvq5y8lxr1ab81wwps07gw00igdkcxnc5k9dzxwc";
  };

  propagatedBuildInputs = [ gflags ];

  meta = with lib; {
    description = "Checks JavaScript files against Google's style guide.";
    homepage = "https://developers.google.com/closure/utilities/";
    license = with licenses; [ asl20 ];
  };

}
