{ stdenv, agda, fetchFromGitHub }:

agda.mkDerivation (self: rec {
  version = "1.4.0";
  name = "agda-iowa-stdlib-${version}";

  src = fetchFromGitHub {
    owner = "cedille";
    repo  = "ial";
    rev = "v${version}";
    sha256 = "1gwxpybxwdj5ipbb3gapm7r5hfl3g6sj9kp13954pdmx8d5b0gma";
  };

  sourceDirectories = [ "./." ];
  buildPhase = ''
    patchShebangs find-deps.sh
    make
  '';

  meta = {
    homepage = https://svn.divms.uiowa.edu/repos/clc/projects/agda/lib/;
    description = "Agda standard library developed at Iowa";
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
