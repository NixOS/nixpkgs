{ stdenv, agda, fetchsvn }:

agda.mkDerivation (self: rec {
  version = "18437";
  name = "agda-iowa-stdlib-${version}";

  src = fetchsvn {
    url = "https://svn.divms.uiowa.edu/repos/clc/projects/agda/lib";
    rev = version;
    sha256 = "1g6pwvrcir53ppf6wd8s62gizc3qy35mp229b66mh53abg4brik2";
  };

  sourceDirectories = [ "./." ];
  buildPhase = ''
    patchShebangs find-deps.sh
    make
  '';

  meta = {
    homepage = "https://svn.divms.uiowa.edu/repos/clc/projects/agda/lib/";
    description = "Agda standard library developed at Iowa";
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    broken = true;
  };
})
