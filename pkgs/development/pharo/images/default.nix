{ callPackage, pharo-vm, ...} @args:

let image = callPackage ./build-image.nix { inherit pharo-vm; }; in

{
  pharo6    = (image "pharo"   "6.0" "http://files.pharo.org/image/60/60465.zip"                          "0l58b1vnda2n0qp22k6n4m415dy79jb35pv6n34dkrxldx1l726b");
  pharo6_64 = (image "pharo64" "6.0" "http://files.pharo.org/image/60/60465-64.zip"                       "0r81f4mhvk8f5al0dayp1qpl23fx59l9zbfzr0j8vcx48x9mw0ln");
  pharo5    = (image "pharo"   "5.0" "http://files.pharo.org/image/50/50771.zip"                          "1r26x671rg4v8i9crcbyi8r6wgsc5i5zc9r26wgg0hx5hin5847d");
  moose61   = (image "moose"   "6.1" "https://ci.inria.fr/moose/job/moose-6.1/681/artifact/moose-6.1.zip" "1wnkr9hm9j2bpmkcar7iks70a0gmgi9z04bibzp9bjxgxpxbm99m");
  launcher  = (image "pharo-launcher" "2017.02.28" "http://files.pharo.org/platform/launcher/PharoLauncher-user-stable-2017.02.28.zip" "1hfwjyx0c47s6ivc1zr2sf5mk1xw2zspsv0ns8mj3kcaglzqwiq0");
}

