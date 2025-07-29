{
  lib,
  stdenv,
  fetchurl,
  coreutils,
  libffi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "txr";
  version = "301";

  src = fetchurl {
    url = "https://www.kylheku.com/cgit/txr/snapshot/txr-${finalAttrs.version}.tar.bz2";
    hash = "sha256-n0irroNVb5UICjspaASO6IGs+zfiD3gK6LyLA+Bppiw=";
  };

  buildInputs = [ libffi ];

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "tests";

  postPatch = ''
    substituteInPlace tests/017/realpath.tl --replace /usr/bin /bin
    substituteInPlace tests/017/realpath.expected --replace /usr/bin /bin

    substituteInPlace tests/018/process.tl --replace /usr/bin/env ${lib.getBin coreutils}/bin/env
  '';

  preCheck =
    let
      disabledTests = lib.concatStringsSep " " [
        # - tries to set sticky bits
        "tests/018/chmod.tl"
        # - warning: unbound function crypt
        "tests/018/crypt.tl"
      ];
    in
    ''
      rm ${disabledTests}
    '';

  postInstall = ''
    mkdir -p $out/share/vim-plugins/txr/{syntax,ftdetect}

    cp {tl,txr}.vim $out/share/vim-plugins/txr/syntax/

    cat > $out/share/vim-plugins/txr/ftdetect/txr.vim <<EOF
      au BufRead,BufNewFile *.txr set filetype=txr | set lisp
      au BufRead,BufNewFile *.tl,*.tlo set filetype=tl | set lisp
    EOF
    mkdir -p $out/share/nvim
    ln -s $out/share/vim-plugins/txr $out/share/nvim/site
  '';

  meta = {
    homepage = "https://nongnu.org/txr";
    description = "Original, New Programming Language for Convenient Data Munging";
    longDescription = ''
      TXR is a general-purpose, multi-paradigm programming language. It
      comprises two languages integrated into a single tool: a text scanning and
      extraction language referred to as the TXR Pattern Language (sometimes
      just "TXR"), and a general-purpose dialect of Lisp called TXR Lisp.

      TXR can be used for everything from "one liner" data transformation tasks
      at the command line, to data scanning and extracting scripts, to full
      application development in a wide range of areas.
    '';
    changelog = "https://www.kylheku.com/cgit/txr/tree/RELNOTES?h=txr-${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      dtzWill
    ];
    platforms = lib.platforms.all;
  };
})
