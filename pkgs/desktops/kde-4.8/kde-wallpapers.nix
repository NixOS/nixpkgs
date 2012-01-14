{ kde, kdelibs }:

kde {

  buildInputs = [ kdelibs ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "101v30x8sw96mq43hs7wzppjc8xhh2wn4qpqbi3nxrb16fw6svad";

  meta = {
    description = "Wallpapers for KDE";
  };
}
