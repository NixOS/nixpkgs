{ lib, buildDunePackage, fetchFromGitHub, ocaml_pcre }:

buildDunePackage rec {
  pname = "duppy";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-duppy";
    rev = "v${version}";
    sha256 = "sha256-5U/CNQ88Wi/AgJEoFeS9O0zTPiD9ysJNQohRVJdyH9w=";
  };

  propagatedBuildInputs = [ ocaml_pcre ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-duppy";
    description = "Library providing monadic threads";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
