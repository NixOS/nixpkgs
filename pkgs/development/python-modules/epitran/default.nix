{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, setuptools
, regex
, panphon
, marisa-trie
, requests
}:

buildPythonPackage rec {
  pname = "epitran";
  version = "1.24";

  src = fetchFromGitHub {
    owner = "dmort27";
    repo = "epitran";
    rev = "refs/tags/${version}";
    hash = "sha256-AH4q8J5oMaUVJ559qe/ZlJXlCcGdxWnxMhnZKCH5Rlk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'panphon>=0.20' 'panphon'
  '';

  propagatedBuildInputs = [
    setuptools
    regex
    panphon
    marisa-trie
    requests
  ];

  meta = with lib; {
    changelog = "https://github.com/dmort27/epitran/releases/tag/${version}";
    description = "A tool for transcribing orthographic text as IPA (International Phonetic Alphabet)";
    homepage = "https://github.com/dmort27/epitran";
    license = licenses.mit;
    maintainers = with maintainers; [ felschr ];
    platforms = platforms.linux;
  };
}
