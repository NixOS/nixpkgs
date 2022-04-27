{ fetchFromSourcehut, lib, qbe, stdenv }:
stdenv.mkDerivation rec {
  pname = "harec";
  version = "unstable-2022-04-28";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = pname;
    rev = "5c9990c863e8eaf8eb47d23b4fb9a73c9ce8056c";
    sha256 = "0fxqb6kqwzxjjr384913naa0rg5wf42b84696q634jdmmhxkcl28";
  };

  strictDeps = true;
  nativeBuildInputs = [ qbe ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://harelang.org";
    description = "Hare programming language bootstrap compiler";
    maintainers = with maintainers; [ ninjin ];
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
  };
}
