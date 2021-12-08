{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "audioread";
  version = "2.1.9";

  src = fetchFromGitHub {
     owner = "sampsyo";
     repo = "audioread";
     rev = "v2.1.9";
     sha256 = "1s1x2xcym69mbcgp6sf5a1dk1kqfn91hd8c5d3sv4r9j0d1skv4p";
  };

  # No tests, need to disable or py3k breaks
  doCheck = false;

  meta = {
    description = "Cross-platform audio decoding";
    homepage = "https://github.com/sampsyo/audioread";
    license = lib.licenses.mit;
  };
}
