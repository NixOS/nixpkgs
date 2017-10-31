{ stdenv, fetchFromGitHub, readline }:

stdenv.mkDerivation rec {
  name = "picoc-${version}";
  version = "2015-05-04";

  src = fetchFromGitHub {
    sha256 = "01w3jwl0vn9fsmh7p20ad4nl9ljzgfn576yvncd9pk9frx3pd8y4";
    rev = "4555e8456f020554bcac50751fbb9b36c7d8c13b";
    repo = "picoc";
    owner = "zsaleeba";
  };

  buildInputs = [ readline ];

  postPatch = ''
    substituteInPlace Makefile --replace '`svnversion -n`' "${version}"
  '';

  enableParallelBuilding = true;

  # Tests are currently broken on i686 see
  # http://hydra.nixos.org/build/24003763/nixlog/1
  doCheck = if stdenv.isi686 then false else true;
  checkTarget = "test";

  installPhase = ''
    install -Dm755 picoc $out/bin/picoc

    mkdir -p $out/include
    install -m644 *.h $out/include
  '';

  meta = with stdenv.lib; {
    description = "Very small C interpreter for scripting";
    longDescription = ''
      PicoC is a very small C interpreter for scripting. It was originally
      written as a script language for a UAV's on-board flight system. It's
      also very suitable for other robotic, embedded and non-embedded
      applications. The core C source code is around 3500 lines of code. It's
      not intended to be a complete implementation of ISO C but it has all the
      essentials. When compiled it only takes a few k of code space and is also
      very sparing of data space. This means it can work well in small embedded
      devices.
    '';
    homepage = https://github.com/zsaleeba/picoc;
    downloadPage = https://code.google.com/p/picoc/downloads/list;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
