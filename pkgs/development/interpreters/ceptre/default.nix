{ stdenv, fetchgit, mlton }:

stdenv.mkDerivation {
  name = "ceptre-2016-11-27";

  src = fetchgit {
    url = https://github.com/chrisamaphone/interactive-lp;
    rev = "e436fda2ccd44e9c9d226feced9d204311deacf5";
    sha256 = "174pxfnw3qyn2w8qxmx45fa68iddf106mkfi0kcmyqxzsc9jprh8";
  };

  nativeBuildInputs = [ mlton ];

  installPhase = ''
    mkdir -p $out/bin
    cp ceptre $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A linear logic programming language for modeling generative interactive systems";
    homepage = https://github.com/chrisamaphone/interactive-lp;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}
