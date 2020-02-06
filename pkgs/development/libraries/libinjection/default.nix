{ stdenv, fetchFromGitHub
, python
}:

stdenv.mkDerivation rec {
  pname   = "libinjection";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner  = "client9";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "0chsgam5dqr9vjfhdcp8cgk7la6nf3lq44zs6z6si98cq743550g";
  };

  nativeBuildInputs = [ python ];

  patchPhase = ''
    patchShebangs src
    substituteInPlace src/Makefile \
      --replace /usr/local $out
  '';

  configurePhase = "cd src";
  buildPhase = "make all";

  # no binaries, so out = library, dev = headers
  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "SQL / SQLI tokenizer parser analyzer";
    homepage    = "https://github.com/client9/libinjection";
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
