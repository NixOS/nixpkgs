{ stdenv, fetchPypi, buildPythonPackage, fetchFromGitHub, python, gnugrep }:

let

  json-ld = fetchFromGitHub {
    owner = "json-ld";
    repo = "json-ld.org";
    rev = "843a70e4523d7cd2a4d3f5325586e726eb1b123f";
    sha256 = "05j0nq6vafclyypxjj30iw898ig0m32nvz0rjdlslx6lawkiwb2a";
  };

  normalization = fetchFromGitHub {
    owner = "json-ld";
    repo = "normalization";
    rev = "aceeaf224b64d6880189d795bd99c3ffadb5d79e";
    sha256 = "125q5rllfm8vg9mz8hn7bhvhv2vqpd86kx2kxlk84smh33l8kbyl";
  };

in

buildPythonPackage rec {
  pname = "PyLD";
  version = "0.7.2";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "digitalbazaar";
    repo = "pyld";
    rev = "652473f828e9a396d4c1db9addbd294fb7db1797";
    sha256 = "1bmpz4s6j7by6l45wwxy7dn7hmrhxc26kbx2hbfy41x29vbjg6j9";
  };

  # Unfortunately PyLD does not pass all testcases in the JSON-LD corpus. We
  # check for at least a minimum amount of successful tests so we know it's not
  # getting worse, at least.
  checkPhase = ''
    ok_min=401

    if ! ${python.interpreter} tests/runtests.py -d ${json-ld}/test-suite 2>&1 | tee test.out; then
      ok_count=$(${gnugrep}/bin/grep -F '... ok' test.out | wc -l)
      if [[ $ok_count -lt $ok_min ]]; then
        echo "Less than $ok_min tests passed ($ok_count). Failing the build."
        exit 1
      fi
    fi

    ${python.interpreter} tests/runtests.py -d ${normalization}/tests
  '';

  meta = with stdenv.lib; {
    description = "Python implementation of the JSON-LD API";
    homepage = https://github.com/digitalbazaar/pyld;
    license = licenses.bsd3;
    maintainers = with maintainers; [ apeschar ];
  };
}
