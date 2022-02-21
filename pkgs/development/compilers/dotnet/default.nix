/*
How to combine packages for use in development:
dotnetCombined = with dotnetCorePackages; combinePackages [ sdk_3_1 sdk_5_0 aspnetcore_5_0 ];

Hashes below are retrived from:
https://dotnet.microsoft.com/download/dotnet
*/
{ callPackage }:
let
  buildDotnet = attrs: callPackage (import ./build-dotnet.nix attrs) {};
  buildAspNetCore = attrs: buildDotnet (attrs // { type = "aspnetcore"; });
  buildNetRuntime = attrs: buildDotnet (attrs // { type = "runtime"; });
  buildNetSdk = attrs: buildDotnet (attrs // { type = "sdk"; });
in
rec {
  combinePackages = attrs: callPackage (import ./combine-packages.nix attrs) {};

  # EOL

  sdk_2_1 = throw "Dotnet SDK 2.1 is EOL, please use 3.1 (LTS), 5.0 (Current) or 6.0 (LTS)";
  sdk_2_2 = throw "Dotnet SDK 2.2 is EOL, please use 3.1 (LTS), 5.0 (Current) or 6.0 (LTS)";
  sdk_3_0 = throw "Dotnet SDK 3.0 is EOL, please use 3.1 (LTS), 5.0 (Current) or 6.0 (LTS)";

  # v3.1 (LTS)

  aspnetcore_3_1 = buildAspNetCore {
    version = "3.1.21";
    sha512 = {
      x86_64-linux = "f59252166dbfe11a78373226222d6a34484b9132e24283222aea8a950a5e9657da2e4d4e9ff8cbcc2fd7c7705e13bf42a31232a6012d1e247efc718e3d8e2df1";
      aarch64-linux = "f3d014431064362c29361e3d3b33b7aaaffe46e22f324cd42ba6fc6a6d5b712153e9ec82f10cf1bee416360a68fb4520dc9c0b0a8860316c4c9fce75f1adae80";
      x86_64-darwin = "477912671e21c7c61f5666323ad9e9c246550d40b4d127ccc71bcb296c86e07051e3c75251beef11806f198eebd0cd4b36790950f24c730dc6723156c0dc11b5";
    };
  };

  runtime_3_1 = buildNetRuntime {
    version = "3.1.21";
    sha512 = {
      x86_64-linux = "cc4b2fef46e94df88bf0fc11cb15439e79bd48da524561dffde80d3cd6db218133468ad2f6785803cf0c13f000d95ff71eb258cec76dd8eb809676ec1cb38fac";
      aarch64-linux = "80971125650a2fa0163e39a2de98bc2e871c295b723559e6081a3ab59d99195aa5b794450f8182c5eb4e7e472ca1c13340ef1cc8a5588114c494bbb5981f19c4";
      x86_64-darwin = "049257f680fe7dfb8e98a2ae4da6aa184f171b04b81c506e7a83509e46b1ea81ea6000c4d01c5bed46d5495328c6d9a0eeecbc0dc7c2c698296251fb04b5e855";
    };
  };

  sdk_3_1 = buildNetSdk {
    version = "3.1.415";
    sha512 = {
      x86_64-linux = "df7a6d1abed609c382799a8f69f129ec72ce68236b2faecf01aed4c957a40a9cfbbc9126381bf517dff3dbe0e488f1092188582701dd0fef09a68b8c5707c747";
      aarch64-linux = "7a5b9922988bcbde63d39f97e283ca1d373d5521cca0ab8946e2f86deaef6e21f00244228a0d5d8c38c2b9634b38bc7338b61984f0e12dd8fdb8b2e6eed5dd34";
      x86_64-darwin = "e26529714021d1828687c404dd0800c61eb267c9da62ee629b91f5ffa8af77d156911bd3c1a58bf11e5c589cfe4a852a95c14a7cb25f731e92a484348868964d";
    };
  };

  # v5.0 (Current)

  aspnetcore_5_0 = buildAspNetCore {
    version = "5.0.12";
    sha512 = {
      x86_64-linux = "0529f23ffa651ac2c2807b70d6e5034f6ae4c88204afdaaa76965ef604d6533f9440d68d9f2cdd3a9f2ca37e9140e6c61a9f9207d430c71140094c7d5c33bf79";
      aarch64-linux = "70570177896943613f0cddeb046ffccaafb1c8245c146383e45fbcfb27779c70dff1ab22c2b13a14bf096173c9279e0a386f61665106a3abb5f623b50281a652";
      x86_64-darwin = "bd9e7dd7f48c220121dde85b3acc4ce7eb2a1944d472f9340276718ef72d033f05fd9a62ffb9de93b8e7633843e731ff1cb5e8c836315f7571f519fdb0a119e1";
    };
  };

  runtime_5_0 = buildNetRuntime {
    version = "5.0.12";
    sha512 = {
      x86_64-linux = "32b5f86db3b1d4c21e3cf616d22f0e4a7374385dac0cf03cdebf3520dcf846460d9677ec1829a180920740a0237d64f6eaa2421d036a67f4fe9fb15d4f6b1db9";
      aarch64-linux = "a8089fad8d21a4b582aa6c3d7162d56a21fee697fd400f050a772f67c2ace5e4196d1c4261d3e861d6dc2e5439666f112c406104d6271e5ab60cda80ef2ffc64";
      x86_64-darwin = "a3160eaec15d0e2b62a4a2cdbb6663ef2e817fd26a3a3b8b3d75c5e3538b2947ff66eaddafb39cc297b9f087794d5fbd5a0e097ec8522ab6fea562f230055264";
    };
  };

  sdk_5_0 = buildNetSdk {
    version = "5.0.403";
    sha512 = {
      x86_64-linux = "7ba5f7f898dba64ea7027dc66184d60ac5ac35fabe750bd509711628442e098413878789fad5766be163fd2867cf22ef482a951e187cf629bbc6f54dd9293a4a";
      aarch64-linux = "6cc705fe45c0d8df6a493eb2923539ef5b62d048d5218859bf3af06fb3934c9c716c16f98ee1a28c818d77adff8430bf39a2ae54a59a1468b704b4ba192234ac";
      x86_64-darwin = "70beea069db182cca211cf04d7a80f3d6a3987d76cbd2bb60590ee76b93a4041b1b86ad91057cddbbaddd501c72327c1bc0a5fec630f38063f84bd60ba2b4792";
    };
  };

  # v6.0 (LTS)

  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.2";
    sha512 = {
      x86_64-linux = "190959576342542bfe51c48808011236e86dcb12779c8e9e444a71f1b778302972ab291adce0c185f6b9790b11867173934968ed88ccb9530266faaa1a05829b";
      aarch64-linux = "00ecdb4343d6f42861157aaef7d892bb3d0e0c0ccd8035305708aaf6bf7095fd6daea2e80cf4fa773aad063d6e510e70cd84d6c1efbd2e3555af6cda0f4b5d31";
      x86_64-darwin = "81b8c4a1e75ad5f258d57fd935c7030f6cfb4b89e2af6d77954c0763acf2e60bb80e696391c8eb368d4bdf92f5f6feda7b0997d621ca14c25dd1b3bb57edab60";
      aarch64-darwin = "dd3af0a25ba1eb6f5904c48a562b38a3651f776237cd4d0282784240a812d9acb98a7a457a8ef3e2a81aac0f4aad516d87bb129ee4332c4c0948bbcbf6c39a16";
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.2";
    sha512 = {
      x86_64-linux = "fa42a686122655a2a7dedc2415bdd618ff06b0a57132d7d98ad79f25c40f3f9edb953ef1ac93fa1a1ff64cffb4c5276dd7586ba5d16c5a7960913e1c5dd646a4";
      aarch64-linux = "5cca54e18332b3297960f21a1b523382e2e7ad6fff477548ac0964451a7db5fadb2acda7cc39bceab184250bd9f81f84162aff4a2ec1d2c4ad278985ed157f4d";
      x86_64-darwin = "7a98ab98ae4587699c8104ea4148dc4f16ee0956c6f434d4e5a506409d0eb365c1f588abef36706014df6e9ee0d82667f4feb9af7a10c7c9ee6a66dae8194953";
      aarch64-darwin = "07c0df0c86fa43d45267d6d6d7a82b24d7c2f951ffbb2f18e5b020d834c97017c80913590ce8116261d250041dd118a9cdef7e57de12ba792ad5b1ace5a60e0f";
    };
  };

  sdk_6_0 = buildNetSdk {
    version = "6.0.102";
    sha512 = {
      x86_64-linux = "edd79ebad3327032ea0aaa8504c14e3270050bb459b098202676776b41a3a1d282aaefd1e5e8aa09ef7f7cf7c4601c4783a57112ff6e3d427507e8eec2bfb748";
      aarch64-linux = "790cbf322ca8fed32eaf574f19d0bdc05656c5a88a65aa4dba8269cfce1443cd7cdeecdd3a40e353c368f055490b70592ca7f15f981a66c5b3a9517d0b09e4cb";
      x86_64-darwin = "2306e62c58eee6e568fd1993ce559b68b0f35be88bf6896a3f60c1e53a65c2dd32d6e107681195fd27758c46caace3a2694e9d4c3b8ae0eb43a896a6f48b3af8";
      aarch64-darwin = "85b7208cb19fc91a75a4a447065d09069ff007974ed3543848345710b55d29e343e3f72bccae821da5b18c2b7c5e7901bed26a39501f6baa0fa1e54549045627";
    };
  };
}
