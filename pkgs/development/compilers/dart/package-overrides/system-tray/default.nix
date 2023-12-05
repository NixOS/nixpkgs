{ libayatana-appindicator
}:

{ ... }:

{ preBuild ? ""
, ...
}:

{
  preBuild = preBuild + ''
    # $PUB_CACHE/hosted is a symlink to a store path.
    mv $PUB_CACHE/hosted $PUB_CACHE/hosted_copy
    cp -HR $PUB_CACHE/hosted_copy $PUB_CACHE/hosted
    substituteInPlace $PUB_CACHE/hosted/pub.dev/system_tray-*/linux/tray.cc \
      --replace "libappindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';
}
