{ buildPythonPackage
, fetchFromGitHub
, lib
}:

buildPythonPackage rec {
  pname = "cooldict";
  version = "unstable-2019-10-29";

  src = fetchFromGitHub {
    owner = "zardus";
    repo = pname;
    rev = "32d56888b555f4513a0e41193bfa49e0e5497a7b";
    sha256 = "1nwf2gd6mx9nm0s9bg0xd5a7b286ph0789fnadri5yd8qqfwr50i";
  };

  # No tests in repo.
  doCheck = false;

  # Verify imports still work.
  pythonImportsCheck = [ "cooldict" ];

  meta = with lib; {
    description = "Some useful dict-like structures";
    homepage = "https://github.com/zardus/cooldict";
    license = licenses.bsd2;
    maintainers = [ maintainers.pamplemousse ];
  };
}
