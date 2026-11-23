{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (eol)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.21";
      hash = "sha512-naOky6WEtfLm5hgU1Hpw6NMcdc9ZPSy5K9F9yc4+2SM0t+i6oPp9XDSQ49SQ7Xb0MdcZB1fytVo254HAGZsYGg==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.21";
        hash = "sha512-4zoScmZFSF2fjCZV6tqG0i9IG0Eh29bwtYJQGD2fWflHoAlYqpnfiU9mfbt6WqpWAEwkZxcEgpcxUIp+XYmTJA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "9.0.21";
        hash = "sha512-JD319UgCane6inWi43a1+ZKVgvAnDjy+dyA3Wk/r6kFwje4sY2s6JjGLccmyH+n4cmDYZD8h8bVu6VKUfJoW2w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "9.0.21";
        hash = "sha512-l4CVaFvJvK2qDdIlK9no58e0A1VZ4OYYmMylNH8Y6scmC/Px2jFiK7EeC3pNAOCHLRRgZy9Ghs+01KQP6nDy6Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.21";
        hash = "sha512-3+QfqhYlfEQfnIiHvuW1wTCRgv2NNB89cLIBOluafvgkxTF0a9Ozj1MreM1yZkvJx8uScSIW2ApLUG+65j8pCg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.21";
        hash = "sha512-UhKgcb3jk7pWIHEwIEWdOyj9mBDhDiLagTFQSsS9z3tmwGQvkMU7aAUfh20zXN3ny6tgsTU647P/cWGXDiJ4MQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "9.0.21";
        hash = "sha512-lMDDBLwoszNUNmTwGGra1zRsdoBDGKmlBdJ+cXqT+bE+2yuv4iT1+59qwU1BwQX6SLF9hmCjd7VJK4S9QQz7ZA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "9.0.21";
        hash = "sha512-kOanPiz14D002UwSybeC3UHnFBRP112Sr+5r/ddtdxHnz+1AbjRyB2sGYKiyhIYS8XwS539i2pDOX9x3cUuKOg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.21";
        hash = "sha512-BUJuLjWhjVS/FBBeNwe2EYE+N2PncRBkpzi0iG+3IpkKbt8cZt2WICtqvMjdn+bJlS9/LIfuhZplN2Gwmneo8w==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.21";
        hash = "sha512-MCrWNoH6iBO0rJEYsRuaYCyw6/YkUpfK0lPwoyjaj7LSS7xZnC5eKRrE7zp+25DeyJBxLubqUpQ4TDvpxVR+dg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "9.0.21";
        hash = "sha512-RzQBRKVpI1V2PMqlfM2Bxc2ZM3kNlJ8swKbthXTUK4U5ajVw9iKGwwbtjDdVY5BpXnbPDyhfypoQuTYl4PPKnA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "9.0.21";
        hash = "sha512-HSs2+GwyrQ+WDAe4kvr2B+wz9hvKEyGlv7kcIipldUyd/8SczZs5xEsbBBIGtNDI1fePz2JSdN0muxDA2qsBGw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.21";
        hash = "sha512-kFQI1xzuGE2SOSsMnGrRjmncVwjiWlIMq/eATOhKlz8HtASgWTgVlaje3YkZ9ZBqBbYmfLLbXwm0q1C2is9D4g==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.21";
        hash = "sha512-Nu+tQDWWgairW/BVDkQtKwhSKRXE344QmHpomkMaHwC9cedyemuqDrxcgGFOnCZoNP7eSGXmSvaunRL4UxSIFQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "9.0.21";
        hash = "sha512-ifQhNCNuGQgFjovkLVswJgx3djNx2w86TIjW3a+JMgjtUNqd7itx1yNMnjxtFB0CzDXpqRqEIZ4VxP1fYZgb+Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "9.0.21";
        hash = "sha512-Wp5zpbh02E3lE1mQx/L47Xr2UTxfysAwj4jc8pthUe9qDdpQ2zMi2Bzc9ww8fTkKGMFYpsFe9X3DcugQXBGPgA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.21";
        hash = "sha512-sP/jSquG2V1dInCsSMOHupV/s6KWxaj1jjizquGmSDsRYNvK+T9oeRaOwQ9ISc603ivCxMEL3qfIDL/Cc600Hw==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.21";
        hash = "sha512-d0bkkyQr//RwDv5NmjUmtVMjWLJ69MqfWnrMy2D+wjWige/3qNFctv6Ft9l7FiMHh/83Jj4DH7FPciIruzgsIQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.21";
        hash = "sha512-nFlpGYydxB7IbSwkJnw5ma6o6tbGgFv/jbGl2xDFY0ABFyD6LVtya9+bLNyDzB+tqdb2/11I/0eaSejQmOl96A==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.21";
        hash = "sha512-ekfH4ovmoKRUIKUA4GZJ1Pu2ntnVXZcdRCrMWYZA4a8pjPqYB5g6hzwvLv/Mo0+bo/+Bg+lmPrL+W2YalyqQVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.21";
        hash = "sha512-Dy3yCGAeaWHBf/zQCSKrLtIs4ue/ejxnjqfnRjKX+EE4UiPE2zumFvZiKrQ9wztArzOHGU74R1467gWNxz+D8w==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.21";
        hash = "sha512-an9HnU4nSYammj/rB0HJV6fgMbVqEIT4yEiVhpJtwXcqjqVIxdRIkPD8F0EFhWhyNmsdcSUOVVgutGAEzotnVw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.21";
        hash = "sha512-S1Vk8zfcb5sNEaY0kXeBlXuZhNZ2u4LoqHV/hOLk03uhlrc5B8e+efgIQETyIhQ4WkGS1qe3pjJIUeGuF7UNDw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.21";
        hash = "sha512-caenT/OZEfa0ct00vTQKvrB1cVai9vcHEt/O0S9IceZdrmWgx61lpNloQuXmy4tFPqtHQVtZZrU4mO99AQBR1w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.21";
        hash = "sha512-rVdi92QPj35cCE+OA1qoRMF9gxRLSnT1sGwNbzytAOzAZh9V6md4vVxvMy6YMZbBZu3eKuPJNGxfeaIIwYeNXg==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.21";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.21";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.21/aspnetcore-runtime-9.0.21-linux-arm64.tar.gz";
        hash = "sha512-uF4vTXcCSmvD77MpAyD3MCzD/HgN0OISG8mN7UKn/Nx+z6I61bgWBUCHuyEQvh/Y4lw8U2NahsX94tikZiX20w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.21/aspnetcore-runtime-9.0.21-linux-x64.tar.gz";
        hash = "sha512-wv0ETDLLTiC70C7G+LWyJuYhHxFACedbu0hdGStuQuhZzKFl1SSEaNHZ1OwfYK2vu5ofISG2LMQyAZ6CENk5Jg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.21/aspnetcore-runtime-9.0.21-osx-arm64.tar.gz";
        hash = "sha512-SnPpnlQRN/BiYZFy3rZPvCIWdERCwbaQFFGS5Yxl9AvoWjInYKuxMENOTGQrkLOYb/xyIkOUDAq5s8H9m18ZTg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.21/aspnetcore-runtime-9.0.21-osx-x64.tar.gz";
        hash = "sha512-/BI1YLgdvy0kmmtpXkOJVqRaKsM7/ZkfLEJE7oSbng6azii+7AOZ0QlL++INnSQQ1zYUVNKzgrmMkdRIAIK3hg==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.21";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.21/dotnet-runtime-9.0.21-linux-arm64.tar.gz";
        hash = "sha512-7meofO7o1PaD8g/ldv4DiG4c7a2QEcPC5SVpOEnyDjeU2OluciCZhczj9LzsaBb67I8x5iBv/B06YHlo94ZtjA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.21/dotnet-runtime-9.0.21-linux-x64.tar.gz";
        hash = "sha512-b6qEfiWgK4fHN8giLG9fn9XyCUW30jmggKfj2ZuXr0jmthIapV3uLnl8yJ/n65fSNeEkIrGyJ4bL8WlCAVauHg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.21/dotnet-runtime-9.0.21-osx-arm64.tar.gz";
        hash = "sha512-Yde0KF4EKGAUXPvp9WzlCaRgxf5rkYQeUXM2VvXXPNX2fWyTkt8R9T+q60LseAj8e3qR15XH7PKljY+n7iKEpQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.21/dotnet-runtime-9.0.21-osx-x64.tar.gz";
        hash = "sha512-5vKa4y0HejRcH6L4wapbnZGvbuv5fn3r2yPxWJz9AaMWWr46nwhr//+/jQw39fr1pNPwNYNwKZylVCpGgbjALQ==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.122";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.122/dotnet-sdk-9.0.122-linux-arm64.tar.gz";
        hash = "sha512-HnY55YxF2qd/Tnw1hynzfSVVxV111RV1m898l9RBNQcA50n/pnnAjxwwOrxMB4YCjmq7I4x7bs2eN8MKnPR1Dg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.122/dotnet-sdk-9.0.122-linux-x64.tar.gz";
        hash = "sha512-ZhrNxI71QeS1kcrsHvl//3gunRXJbUelPzimDHOxFZGrRuurtzEGbmINiXV7kQbyTQj5n358UKPq68tTlGdKcw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.122/dotnet-sdk-9.0.122-osx-arm64.tar.gz";
        hash = "sha512-j62WDOKtJAbQ6cod5MrKDi+k7WTTHIOn13vvJodqNmlYDGLJ/dJ3wtdbHKR9fascNWXp/46zW7kgq7NsYzpYyA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.122/dotnet-sdk-9.0.122-osx-x64.tar.gz";
        hash = "sha512-riqC2pdrWH2RyLXiAGT5HXvX2y9TDtWyiBh8smsnt6M56c2FHvhfkJyp6PssKq8zAKfH45i+eGkpDJLDSckMDQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk = sdk_9_0;

  sdk_9_0 = sdk_9_0_1xx;
}
