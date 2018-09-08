{ lib
, mkGuileModule
, fetchFromGitLab
, guile-bytestructures
, libffi
, libgit2
}:

mkGuileModule rec {
  pname = "guile-git";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1z3awa3i5il08dl2swbnli2j7cawdpray11zx4844j27bxqddcs2";
  };

  buildInputs = [
    guile-bytestructures
    libffi
    libgit2
  ];

  meta = with lib; {
    description = "guile bindings of libgit2";
    homepage = "https://gitlab.com/guile-git/guile-git";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.gnu ++ platforms.linux;
  };
}
