{
  lib,
  stdenv,
  fetchurl,
  erlang,
  cl,
  libGL,
  libGLU,
  libigl,
  eigen,
  runtimeShell,
}:
stdenv.mkDerivation rec {
  pname = "wings";
  version = "2.3";

  src = fetchurl {
    url = "mirror://sourceforge/wings/wings-${version}.tar.bz2";
    sha256 = "sha256-dEf6iPbPCLmMqvWjvgEROVACZW8SCsXKi3TWlic+bws=";
  };

  postPatch = ''
    find . -type f -name "Makefile" -exec sed -i 's,-Werror ,,' {} \;
    sed -i 's,../../wings/,../,' icons/Makefile
    find plugins_src -mindepth 2 -type f -name "*.[eh]rl" -exec sed -i 's,wings/src/,../../src/,' {} \;
    find plugins_src -mindepth 2 -type f -name "*.[eh]rl" -exec sed -i 's,wings/e3d/,../../e3d/,' {} \;
    find plugins_src -mindepth 2 -type f -name "*.[eh]rl" -exec sed -i 's,wings/intl_tools/,../../intl_tools/,' {} \;
    find . -type f -name "*.[eh]rl" -exec sed -i 's,wings/src/,../src/,' {} \;
    find . -type f -name "*.[eh]rl" -exec sed -i 's,wings/e3d/,../e3d/,' {} \;
    find . -type f -name "*.[eh]rl" -exec sed -i 's,wings/intl_tools/,../intl_tools/,' {} \;
    # Remove external dependency rules (such as libigl, eigen, cl)
    find . -type f -name "Makefile" -exec sed -i 's,libigl: _deps/libigl,,g' {} \;
    find . -type f -name "Makefile" -exec sed -i 's,eigen: _deps/eigen,,g' {} \;
    find . -type f -name "Makefile" -exec sed -i 's,cl: _deps/cl,,g' {} \;
    # The following lines were added during an update to 2.3 due to changes to the Makefile. Chances are
    # there are better ways to do this, but I'm not aware if there are. PRs welcome.
    # Remove any targets that depend on these dependencies (e.g., c_src)
    find . -type f -name "Makefile" -exec sed -i 's,c_src: $(DEPS),c_src:,g' {} \;
    find . -type f -name "Makefile" -exec sed -i 's,src: intl_tools e3d,src: intl_tools,g' {} \;
    find . -type f -name "Makefile" -exec sed -i 's,plugins_src: intl_tools src,plugins_src: intl_tools,g' {} \;
    # Make sure the Makefile is able to find Eigen. Without this line, it will fail.
    find . -type f -name "Makefile" -exec sed -i 's,-I../_deps/eigen,-I${eigen}/include/eigen3,' {} \;
  '';

  buildInputs = [
    erlang
    cl
    libGL
    libGLU
    libigl
    eigen
  ];

  ERL_LIBS = "${cl}/lib/erlang/lib";

  # I did not test the *cl* part. I added the -pa just by imitation.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/wings-${version}/ebin
    cp ebin/* $out/lib/wings-${version}/ebin
    cp -R textures shaders plugins $out/lib/wings-${version}
    cat << EOF > $out/bin/wings
    #!${runtimeShell}
    ${erlang}/bin/erl \
      -pa $out/lib/wings-${version}/ebin -run wings_start start_halt "$@"
    EOF

    chmod +x $out/bin/wings
    runHook postInstall
  '';

  meta = {
    homepage = "http://www.wings3d.com/";
    description = "Subdivision modeler inspired by Nendo and Mirai from Izware";
    license = lib.licenses.tcltk;
    maintainers = with lib.maintainers; [ NotAShelf ];
    platforms = lib.platforms.linux;
    mainProgram = "wings";
  };
}
