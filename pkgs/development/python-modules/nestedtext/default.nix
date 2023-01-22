{ lib, buildPythonPackage, fetchFromGitHub
, inform
, pytestCheckHook
, docopt
, natsort
, voluptuous
}:

buildPythonPackage rec {
  pname = "nestedtext";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "nestedtext";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "1dwks5apghg29aj90nc4qm0chk195jh881297zr1wk7mqd2n159y";
  };

  propagatedBuildInputs = [ inform ];

  nativeCheckInputs = [ pytestCheckHook docopt natsort voluptuous ];
  pytestFlagsArray = [ "--ignore=build" ]; # Avoids an ImportMismatchError.

  meta = with lib; {
    description = "A human friendly data format";
    longDescription = ''
      NestedText is a file format for holding data that is to be entered,
      edited, or viewed by people. It allows data to be organized into a nested
      collection of dictionaries, lists, and strings. In this way it is similar
      to JSON, YAML and TOML, but without the complexity and risk of YAML and
      without the syntactic clutter of JSON and TOML. NestedText is both simple
      and natural. Only a small number of concepts and rules must be kept in
      mind when creating it. It is easily created, modified, or viewed with a
      text editor and easily understood and used by both programmers and
      non-programmers.
    '';
    homepage = "https://nestedtext.org";
    license = licenses.mit;
    maintainers = with maintainers; [ jeremyschlatter ];
  };
}
