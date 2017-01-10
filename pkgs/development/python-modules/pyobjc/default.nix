{ stdenv, fetchurl, pkgs, buildPythonPackage }:

let

  buildPyObjcFramework = _name: version: sha256: extraDeps:
    buildPythonPackage rec {
      name = "${pname}-${version}";
      pname = "pyobjc-framework-${_name}";

      propagatedBuildInputs = [ pyobjc-core ]
        ++ stdenv.lib.optional (builtins.hasAttr _name pkgs.darwin.apple_sdk.frameworks) (builtins.getAttr _name pkgs.darwin.apple_sdk.frameworks)
        ++ extraDeps;

      patchPhase = ''
        # hack to force 10.9 sdk
        substituteInPlace pyobjc_setup.py \
          --replace '"-DPyObjC_BUILD_RELEASE=%02d%02d"' '"-DPyObjC_BUILD_RELEASE=1009"]#'
      '' + stdenv.lib.optionalString (_name == "AVFoundation") ''
        # messy patches (fixed in 3.2)
        sed -i -e '11i#if PyObjC_BUILD_RELEASE >= 1010' -e '15i#endif' Modules/_AVFoundation_inlines.m
        sed -i -e '20i#if PyObjC_BUILD_RELEASE >= 1010' -e '22i#endif' Modules/_AVFoundation_protocols.m
      '';

      doCheck = false;

      src = fetchurl {
        url = "mirror://pypi/p/${pname}/${name}.tar.gz";
        inherit sha256;
      };

      meta = {
        platforms = stdenv.lib.platforms.darwin;
        description = "Wrappers for the framework ${_name} on Mac OS X";
        maintainers = [ stdenv.lib.maintainers.matthewbauer ];
        license = stdenv.lib.licenses.mit;
      };
    };

  frameworks = rec { # 3.1.1 corresponds to SDK 10.9 because we only have CF 10.9
    Accounts = buildPyObjcFramework "Accounts" "3.1.1" "1jgasyz88mhl58ks1k06qqxd6ifzbkcjkir6ny0hjr6vc07lk99h" [ Cocoa ];
    AddressBook = buildPyObjcFramework "AddressBook" "3.1.1" "1p38d8km2kmmzx8b87c63zg7pncfq9wyik6z6whh3059hdnxax7k" [ Cocoa ];
    AppleScriptKit = buildPyObjcFramework "AppleScriptKit" "3.1.1" "07dm1j8ca1ljcr8xiq6nzc8x7mvawhlsazlk7rwszhnpjdpyy2h7" [ Cocoa ];
    AppleScriptObjC = buildPyObjcFramework "AppleScriptObjC" "3.1.1" "15cksckgw7rmckanz8yzjw9qqwrbvc99bj3wpixzfzsnwr473n8y" [ Cocoa ];
    ApplicationServices = buildPyObjcFramework "ApplicationServices" "3.1.1" "19bhxqwhna22mk4cisyji738snpzbmbm13qyn21hk0wjfffn7zd3" [ Quartz ];
    Automator = buildPyObjcFramework "Automator" "3.1.1" "1hdf1kzlli1k8nh1aiphzc9f0j7g8n7720iirsr27f7gk1n99zlg" [ Cocoa ];
    AVFoundation = buildPyObjcFramework "AVFoundation" "3.1.1" "05h0qv2zd3692m59lq3grq5igh9jank8njzlxx0g5810wxd313ld" [ Quartz pkgs.darwin.apple_sdk.frameworks.AddressBook ];
    AVKit = buildPyObjcFramework "AVKit" "3.1.1" "1xiwq93gk0z0i82cvilzi1h61nb7y4hvlpvw3f9zllhg30ndxlvj" [ Quartz ];
    CalendarStore = buildPyObjcFramework "CalendarStore" "3.1.1" "0k6msh0469azqz2zkhhp6m2rjf4z0frg3n08ypqmiph9vqpzklnh" [ Cocoa ];
    CFNetwork = buildPyObjcFramework "CFNetwork" "3.1.1" "1dr42r1w8319w9s9iqlhkciikiyqh147c94g2r2zdq76y6nlphzj" [ Cocoa ];
    # CloudKit = buildPyObjcFramework "CloudKit" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    Cocoa = buildPyObjcFramework "Cocoa" "3.1.1" "145hny44yhdrpa1lk1189lr753hinfyylbc43bm6fff3i461zcmm" [];
    Collaboration = buildPyObjcFramework "Collaboration" "3.1.1" "1sbv5zdn48pw6z8lxdhsg48gh0md49rz32rvn50kb6dwzbh7bdan" [ Cocoa ];
    # Contacts = buildPyObjcFramework "Contacts" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    # ContactsUI = buildPyObjcFramework "ContactsUI" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    # CoreBluetooth = buildPyObjcFramework "CoreBluetooth" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    CoreData = buildPyObjcFramework "CoreData" "3.1.1" "138n4jj9j5hcbrxhx3ys39pc9mjih48w3dra4ngq63gy6867pzpb" [ Cocoa ];
    CoreLocation = buildPyObjcFramework "CoreLocation" "3.1.1" "0r3bgik5j5l8pv81cnk4y6815ylpy1xc35cpw4hwzhvsh4hl2yhm" [ Cocoa ];
    CoreText = buildPyObjcFramework "CoreText" "3.1.1" "0z3xnp1kb3ckjfm04nk0vd7dy8mi1a9c471zlflb0i4zmhs5hzh3" [ Quartz ];
    CoreWLAN = buildPyObjcFramework "CoreWLAN" "3.1.1" "1izfdxri9dipijc0di9prkk83cw35fd38cl01b97d8y55rlsblbj" [ Cocoa ];
    # CryptoTokenKit = buildPyObjcFramework "CryptoTokenKit" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    DictionaryServices = buildPyObjcFramework "DictionaryServices" "3.1.1" "1c3pqzfn5q36yzpyww1xfnk0c81w8vmkp3wibjpjlvz7c816d341" [ Cocoa ];
    DiskArbitration = buildPyObjcFramework "DiskArbitration" "3.1.1" "1zmbvb1nrfa5xi4r7lzqn8xhnh9i4gxv7nsph9ljlb04jdfx2hy3" [ Cocoa ];
    EventKit = buildPyObjcFramework "EventKit" "3.1.1" "0rifbs5sdr5vwjswz5nkwfa28k74w66bh4vnva12yqgnhs513l59" [ Cocoa ];
    ExceptionHandling = buildPyObjcFramework "ExceptionHandling" "3.1.1" "0pw21i9bwv9npbcfx3kk7kzcarkgh92ncwrn7j6y7gd0yavqrqgq" [ Cocoa ];
    # FinderSync = buildPyObjcFramework "FinderSync" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    FSEvents = buildPyObjcFramework "FSEvents" "3.1.1" "0hjg3y4dv88m0wgb9r0in55753ys4z8yc1k0zw98i85yzq3dpy7b" [ Cocoa ];
    # GameCenter = buildPyObjcFramework "GameCenter" "3.1.1" "072jx3gnq88alpdmkm61ihb35m8f2ag2pwjc2as178v1cnx1jkxi" [ pkgs.darwin.apple_sdk.frameworks.GameKit ];
    GameController = buildPyObjcFramework "GameController" "3.1.1" "0i6s98f6zqpj08z3xkfk1zz0ccgsa7rxv5p3djplap5yvpq5gzys" [ Cocoa ];
    ImageCaptureCore = buildPyObjcFramework "ImageCaptureCore" "3.1.1" "08yhjng6mi37qddas4bhi131qmcgpkjsxf80viy35v33w0249gf9" [ Cocoa ];
    IMServicePlugIn = buildPyObjcFramework "IMServicePlugIn" "3.1.1" "0440qplpx6xv93347ig6mb1hlva2bg3l9hlh51mcnxxwyzlr6nzm" [ pkgs.darwin.apple_sdk.frameworks.GameKit Cocoa ];
    InputMethodKit = buildPyObjcFramework "InputMethodKit" "3.1.1" "0npzkazyf97f8p23sd14dyn0mg5vdb289d966kjdwysp92w51ni3" [ Cocoa ];
    InstallerPlugins = buildPyObjcFramework "InstallerPlugins" "3.1.1" "1aiscs2zg8sz9v2rg2lbpcjb9j7z1q5cbhjwimjpvfqh8nkd6gw2" [ Cocoa ];
    InstantMessage = buildPyObjcFramework "InstantMessage" "3.1.1" "1fscnrm17m5csqkcf68wnq1lmg59ikm4vi8kiyndxc71qibsxlpv" [ Quartz ];
    # Intents = buildPyObjcFramework "Intents" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    # InterfaceBuilderKit = buildPyObjcFramework "InterfaceBuilderKit" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    # IOSurface = buildPyObjcFramework "IOSurface" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    LatentSemanticMapping = buildPyObjcFramework "LatentSemanticMapping" "3.1.1" "04rvv5prn0wc2qsy577vwmg8ifvnwk8p7f52cki24a082dwinjq1" [ Cocoa ];
    LaunchServices = buildPyObjcFramework "LaunchServices" "3.1.1" "0zvily0id9np5px2qm86i0zkwk2j5zj80aws3v0f6a5zk92b1mvf" [ Cocoa ];
    LocalAuthentication = buildPyObjcFramework "LocalAuthentication" "3.1.1" "0k2finq1xwmsc1qb54rx41638a5rszyhjfw2j3qbhrnl55k0r4sc" [ Cocoa ];
    MapKit = buildPyObjcFramework "MapKit" "3.1.1" "1rkb2ssfa85pjnaz17hyrhm9rbmfimkhpn7kgf2iajn2bcpw164k" [ Quartz CoreLocation ];
    MediaAccessibility = buildPyObjcFramework "MediaAccessibility" "3.1.1" "018389493b4rl5kbypgalsgh89x0bbdd1y5xm3768v1hl2kg6p0x" [ Cocoa ];
    MediaLibrary = buildPyObjcFramework "MediaLibrary" "3.1.1" "1bii8vwly7ihp5zr3qzvbya9p8aasqwb4nxw66r2f2430zq6440v" [ Quartz ];
    # MediaPlayer = buildPyObjcFramework "MediaPlayer" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    # Message = buildPyObjcFramework "Message" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    # ModelIO = buildPyObjcFramework "ModelIO" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    # MultipeerConnectivity = buildPyObjcFramework "MultipeerConnectivity" "3.1.1" "0p1hh0cckra9z6a2f5xcnpmmppiy2yhjr99va403d5jx39vhy0yz" [];
    NetFS = buildPyObjcFramework "NetFS" "3.1.1" "1iz2l25ydhp983fp3by8r48542v3y5f2l0sdkld1xw8hxxaylk8j" [ Cocoa ];
    # NetworkExtension = buildPyObjcFramework "NetworkExtension" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    # NotificationCenter = buildPyObjcFramework "NotificationCenter" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    OpenDirectory = buildPyObjcFramework "OpenDirectory" "3.1.1" "0g3z8v6rsz8s6zq3fdwwa1a5linv4jn1fxm4wkfmvf659p7bmis0" [ Cocoa ];
    Photos = buildPyObjcFramework "Photos" "3.1.1" "1zvzf41d67vbsqzmycjwflrigx0fnhdcydk5pfch3bm2ix8bd3js" [ Cocoa ];
    # PhotosUI = buildPyObjcFramework "PhotosUI" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    PreferencePanes = buildPyObjcFramework "PreferencePanes" "3.1.1" "1dww160x6d54mqmafraa5cw50ygv39r2000hjfcv4hyn6xs1wlqs" [ Cocoa ];
    PubSub = buildPyObjcFramework "PubSub" "3.1.1" "03z6p1hg46sfsjxdqcnn7qyzf0y07nwl034ka7z97r4nww6pc6pg" [ Cocoa ];
    QTKit = buildPyObjcFramework "QTKit" "3.1.1" "04hrpcgsimmf4iqnrazjnvb2xh0yf2rk6jfi6lcl5vw1bi3igs78" [ Quartz ];
    Quartz = buildPyObjcFramework "Quartz" "3.1.1" "0xc0xx35i8vv0809mcpgh3l18r2h23mqx5py5nrzll8h256gvs28" [ Cocoa ];
    # SafariServices = buildPyObjcFramework "SafariServices" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    # SceneKit = buildPyObjcFramework "SceneKit" "3.1.1" "1b1fh60chzvrcnfgqnf3rd5kryyhimf8s1fg537r9kspzspqv73l" [];
    ScreenSaver = buildPyObjcFramework "ScreenSaver" "3.1.1" "13i6mqsfzd1qaz10dmcx9s636kbggx7wlaapf5nzha0aqdhgda4b" [ Cocoa ];
    ScriptingBridge = buildPyObjcFramework "ScriptingBridge" "3.1.1" "09y426raixpk1sayb17iabwh4b78bi06xqxra2p3fy6dhbv0rmmp" [ Cocoa ];
    SearchKit = buildPyObjcFramework "SearchKit" "3.1.1" "1h8c53hwm8qwdd81in9cszsmacn4470c911vh2q29j7g2zw03gs9" [ Cocoa ];
    # ServerNotification = buildPyObjcFramework "ServerNotification" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    ServiceManagement = buildPyObjcFramework "ServiceManagement" "3.1.1" "0609mqnzllgb0jq0z98sqpg9aaxkp74zy795ii6ghd18vmnfj3nf" [ Cocoa ];
    # SpriteKit = buildPyObjcFramework "SpriteKit" "3.1.1" "0zfmnh7fcnlxdvjj4hrvqsq3ysqzmbr1sh6rfqdx21md97cdd8y7" [];
    StoreKit = buildPyObjcFramework "StoreKit" "3.1.1" "1n2x75xr5m3kv5pjf0n88ij9qkxdbd58ddpxmjijlqrv7ckj3n3k" [ Cocoa ];
    SyncServices = buildPyObjcFramework "SyncServices" "3.1.1" "1bqrjsvmawx4h1yyspfr765s1mj55vr09l1fjcx5gwfv3g7z2i98" [ CoreData ];
    SystemConfiguration = buildPyObjcFramework "SystemConfiguration" "3.1.1" "135bmhlp7i40syk627pyk0lglmfar5h6sdigwhz7d5adg0pgq2fz" [ Cocoa ];
    WebKit = buildPyObjcFramework "WebKit" "3.1.1" "0zlmddinsz30wa89dbl1wvh3fs75zgfd3dxhqw4c4zg02vwgg4i2" [ Cocoa ];
    # XgridFoundation = buildPyObjcFramework "XgridFoundation" "3.1.1" "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn620" [];
    Social = buildPyObjcFramework "Social" "3.1.1" "0qmrpcriv2ppl0mn9viw76ibg3k206c62bsa748jiqy4p1pxxrqm" [ Cocoa ];
};

pyobjc-core = buildPythonPackage rec {
  name = "${pname}-3.1.1";
  pname = "pyobjc-core";

  src = fetchurl {
    url = "mirror://pypi/p/${pname}/${name}.tar.gz";
    sha256 = "0bkxcyrd3h1qlmpx145lcxjv21mkrpdvgwbbv0f8iv2vzb2fki07";
  };

  postUnpack = ''
    # HACK: make sure SDKROOT is setup correctly
    export SDKROOT=${pkgs.xcbuild}
  '';

  doCheck = false;

  propagatedBuildInputs = with pkgs.darwin; [
    objc4
    apple_sdk.frameworks.Foundation
    apple_sdk.frameworks.Carbon
    apple_sdk.frameworks.Cocoa
  ];

  meta = {
    description = "Python<->ObjC Interoperability Module";
    platforms = stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.matthewbauer ];
    license = stdenv.lib.licenses.mit;
  };
};

in

buildPythonPackage rec {
  name = "${pname}-3.1.1";
  pname = "pyobjc";

  src = fetchurl {
    url = "mirror://pypi/p/${pname}/${name}.tar.gz";
    sha256 = "0xg67z5lp2glxixj9hpcpws55hf163x9ak8d9jplxqcl8bqkn62d";
  };

  propagatedBuildInputs = [ pyobjc-core pkgs.pythonPackages.py2app ] ++ builtins.attrValues frameworks;

  postPatch = ''
    substituteInPlace setup.py \
      --replace "('SpriteKit',               '10.9',             None        )," "" \
      --replace "('GameCenter',              '10.8',             None        )," "" \
      --replace "('SceneKit',                '10.7',             None        )," "" \
      --replace "platform.mac_ver()[0]" '"10.9"'
  '';

  doCheck = false;

  meta = {
    description = "Python<->ObjC Interoperability Module";
    platforms = stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.matthewbauer ];
    license = stdenv.lib.licenses.mit;
  };
}
