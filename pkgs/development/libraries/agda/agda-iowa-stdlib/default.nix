{ stdenv, agda, fetchsvn }:

agda.mkDerivation (self: rec {
  version = "18734";
  name = "agda-iowa-stdlib-${version}";

  src = fetchsvn {
    url = "https://svn.divms.uiowa.edu/repos/clc/projects/agda/lib";
    rev = version;
    sha256 = "0aqib88m5n6aqb5lmns9nl62x40yqhg6zpj0zjxibbn4s4qjw9ky";
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

    broken = true;
  };
})
