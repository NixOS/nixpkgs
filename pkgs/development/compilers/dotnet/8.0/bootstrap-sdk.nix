{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.27";
      hash = "sha512-WndxmklJY4EjecTSMbfO+oAdO2nHLGUoVSlb+Lv853sNxQnwxDDl2Ff+G04S6jT2AfqsCh6WX3b56ewOwVKRyQ==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.27";
        hash = "sha512-bErrdAIQR855a8in/TGCReskuIS16VvWWQpWROznmLellb8ClL6MyrCrRxDeqRH781JCr7Se4eq36tD5KSpSxg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.27";
        hash = "sha512-i2LdD5Tt4B2JSaD/hegIHq/0WFc/KCWBCpn7HrGqp3r1g903txcxmT+rJbrBzI6CGRgXoOjnq75kqvGEZ8M3KQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.27";
        hash = "sha512-2p6hfoIr7cn09mCTZoRTzVKpXqLo669BINHJOafB3pe1X9uoFkeB5dCtLJrOBj0ZPoKMIwG63aZB5vQ+5EF/0w==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.27";
        hash = "sha512-c53DhZ/hMq9FIMUCjP+4bd78ABzcPzt8SDbjYwf0lkTqJTrb12OdafiN28decGEy7IVRMMUge7tkRhYu/7Bxyw==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.27";
        hash = "sha512-MsxhBKxafcCgvzxyojeTclpec3NjRiXFJrR00/BdLIqJHTeF8J5ZiBeDRBIbn3ZYZzB+mj8MMUiEYcK0Wpqxpg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.27";
        hash = "sha512-Vlwfi89vSKQf0p4kYCYbOVQo0S+fmgkCzp/1L34H+zHJYP2T2W9uWzNmFV7M2/cv7AHBzl3AwiyiZkdlrsbfOA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.27";
        hash = "sha512-t1BGOmN7AAqzHUzHK9peyGhats+fo/6wwnyh0JAodPi8aq1YZIAqWPKyCU7qqMh1AQR33VvI0qR5ZrmybjwdiA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.27";
        hash = "sha512-FnI3egtVAblHpS8463WvLmGAY1lTNM2YcaoMcShtY4b95Ofi2oTKdMkMdaYlBqI9RxcSw+dbOi2dpC9d1Q2Bzg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.27";
        hash = "sha512-vlT/OPJEstLZ/yEq371tZuQrWzDFZZSHqtj/JoenV5U18e1zdQivnDGHDZ6x5JNzDcTEeMk122yEAaBp3+nfhA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.27";
        hash = "sha512-Je7H4Unx9bF1hef5kcudKl45w5QB4v2G1Oc386QUC00QMrOmM74yzTLSpNEUUlcs2XQ9FmBj1WXcxSbgZgxmeA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.27";
        hash = "sha512-DrHPM/204IfDE+tWSPSMnduvzOSoivEJS9DPw/ssmLjhutqyrlqasChfc+Yy4M8r+QMD256ydDw13AN80gi9xQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.27";
        hash = "sha512-hdtBM8bYISs9ryqPiZG1U1ltt4c1jr1Co6MG08Mam0HObhJ9dTzRu5TYdaarEwOarMswdcWeKxOWzC+4w26xgA==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.27";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.27";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.27/aspnetcore-runtime-8.0.27-linux-arm64.tar.gz";
        hash = "sha512-X3bWGD5NXZD4Zyq8hlQ2YG7VUVk6dXceVrNSF5ekja3W9t4f+TwmJGYqxZeVp86KzXKYxd6ImxmLEG16ebjBFA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.27/aspnetcore-runtime-8.0.27-linux-x64.tar.gz";
        hash = "sha512-T5SK+RQjY2yKi72a0vnitZl7hOhO82cH4+MlDutPANC8mO0UQhUdGRO6IbsEdboq2y1tYyipPb5xBfLAvKKryQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.27/aspnetcore-runtime-8.0.27-osx-arm64.tar.gz";
        hash = "sha512-PfVOaBw06GGqApF3RaEmvfawZo1NyQnK6SDRxLcl6ISxqhFVQlGjIruo51Lua2y7Gfa17anoMMQmtZBE4ywphA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.27/aspnetcore-runtime-8.0.27-osx-x64.tar.gz";
        hash = "sha512-pl4qysIVdbSPS+jU1PDxL8TFlw4X4lJ3+jacXHm8Jj/pyLidlHm4lCw1YcIipBin6e3ab4m60u+hRzgPoystRA==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.27";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.27/dotnet-runtime-8.0.27-linux-arm64.tar.gz";
        hash = "sha512-nsMzIjbHXRy2r7DyiVA+ARqSV4v67NQT4IQqoo8Z5IbbW5popFswCN9g1VrXXWXsY27TlUPBGCuoFkM3jUs/hw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.27/dotnet-runtime-8.0.27-linux-x64.tar.gz";
        hash = "sha512-y+/+OhPS2MjG6kG4p2mJe0o8L0LY4L7AQoEL+k6anDsg+lOac5Rd4yTR35r6p0eeaW5KR/VI9CbiMQXhoDvoSw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.27/dotnet-runtime-8.0.27-osx-arm64.tar.gz";
        hash = "sha512-aVqXB6HYts5ygjDFB1MmJto3pZpXIyplf9jOA/AqwXckb/vk9TnUxUUfqARgkBRxj9cjacpc+p3H8aDwvby0Zw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.27/dotnet-runtime-8.0.27-osx-x64.tar.gz";
        hash = "sha512-mkp7flXtvqtpfeurmXKBOJGX1IRc3JFsCvO9XKH53D1Em3abKwdLnJWuJzttYADj7iwaVRhV54m7io5DssCNBg==";
      };
    };
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.127";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.127/dotnet-sdk-8.0.127-linux-arm64.tar.gz";
        hash = "sha512-iLYKbh+GI4R4SOkx1JomKSjyoCxpyvu5oQE85p0Jv1iiNJ8JUnImDlnMsIAgzyFIEdhtBTWty3fPXWYOGVG7Rw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.127/dotnet-sdk-8.0.127-linux-x64.tar.gz";
        hash = "sha512-sZ2GGd0D5RasZnHgNR638ACTADlj7u9bs/BxY6TGZrFkHqWv1MFG3cpKOF8fxql8NxHgfwAjG34nrR/b1QL91Q==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.127/dotnet-sdk-8.0.127-osx-arm64.tar.gz";
        hash = "sha512-Da//WTe6RLlDX44ohM0cJxhUAMjVY5B+hLMbMdknDUviAplNZ9c3iC+DptGX8/zE3YuT0dLvd7FGlBj7rE74AA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.127/dotnet-sdk-8.0.127-osx-x64.tar.gz";
        hash = "sha512-ItkkWweADUn9Yg9T8gxQvG9wldlIVSy7kRK/BT0CONauiUtZnBgsq3rgqwAXaS/FbzsGLXkgeEdYOweJZ0RpEQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk = sdk_8_0;

  sdk_8_0 = sdk_8_0_1xx;
}
