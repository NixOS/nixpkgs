{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.20";
      hash = "sha512-KKQLfBwHbSybzNk647Kk+rn8iiWYx0H2NQMfjT5n8Bc5hCOvotwzDdVLe/jELMmvcWtOb9FNxJdQFti9oDtaig==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.20";
        hash = "sha512-hbcxgbYk1p7Fun8Gkq5+hVd+kgf9OtwsZDyNgrYqmz+E4cx5YvTk0TYGo0V49rtTqEl8hkNd+FOBZfn1geRrUw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "9.0.20";
        hash = "sha512-UykANzWZy130j7SE5ZsFoPi9imOZEJ1cadkOm+wgDKoJIaSA4JGnAffpxvbuFD05/iIiHxDnKAEMh7Yrn45Z9Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "9.0.20";
        hash = "sha512-fAVaXUdyb/01GdC8t+lQ3Oy1CGohuSsuPQ7/YWZ7KOlTsrEaL+mIe6Ocvj1+jqHYQ+/T6pyJWFKQFTeagNmiFg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.20";
        hash = "sha512-b4HTAl6FLb4mi145KBZx9kkt9MtgcnAp5kJEKi/F0nwWYE+D7rr081x0FSIudMqW1xh1n7A9hyu2syBLcYoqxQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.20";
        hash = "sha512-Sa+CxheFvErWZmo+/+hXcWM1p41sdm3RZPyVnTIMzQ1XZBSGHcdYhUeQQhrX/DlEnN70KAt3NMfxCPwznyit1w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "9.0.20";
        hash = "sha512-LKcrun0M7XopJCd4PY4JBFaAYsfUplWFTytY6A7Ihpns9axpF4gy9Fq6xsZTFQTQGrgEfNohLSCxeXiaApOTFg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "9.0.20";
        hash = "sha512-5C7gF8L5320aK1hS+rG/G252ncUFI4hrgh6/maj7bbGpIUEb5ngZFQGEKbynm85EUd23YKFcORGsaTO3i+1qiw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.20";
        hash = "sha512-GQG4JoxIiDZZrXaNQk7nYJ4kIMxoQbS/wEQCVZQN2w0ZbaaTdxmzkDrRBTa3BUwI7vpNS75hYg4paFLwv88SEQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.20";
        hash = "sha512-2Q8F1FH+3PCPY+HTGPkyGuFVOHeVVkUFT4EGnM0TDXjmxopHxnR/7tJWFx0t/wGKCepAlOFI93AkO8nfKPOLiA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "9.0.20";
        hash = "sha512-gMU8WABAmxvxnfWe/l+gX0lgJ4KYpUWqxs8Z5sto+EXTgD9Svg4O7KfTXjV6LfF9Sp1O096m2EbxfUM8xXMvoQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "9.0.20";
        hash = "sha512-bDMguejOyRAnDj4kpAGlANP0uCSxeKY+7X4QJxr+JP8CnZ/iGE2gzlo1aOasHXTk2i4NE4WZzUAH1xI39iU9hQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.20";
        hash = "sha512-3YXVr7fbtPC2H3Ny+X8kszjDsxSjwGQqgg5/I48/m7vuA0O1mIcG7z9poLJ5yeZSzYxad1OAl/49/3iPXv5KXA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.20";
        hash = "sha512-YngxfB1iwWptOcblyAORzazZ3e5pQO5rB76Exl2wBNaBNhARlqBPFB6K5vZkeYyqZXkGCMleHQf3jQxsxt7EPA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "9.0.20";
        hash = "sha512-u3fL1BlObveTCrVJEiE7agnmcY0NTNFJeESFSqyV5U7JoE5w9NIoJI+BdAzBz3z5Olx0VgOx4WZM/TtOeLj1DQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "9.0.20";
        hash = "sha512-VynsOQJKXvVG8a1QUxHh6PhAud/oO44UeHAbFdSvAQWs20R5soWqzKpKZOUzpBbehNO38gxb6Q8ibGcdO2e6+A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.20";
        hash = "sha512-pCU2rtmnGKFKzjv8ZU/PFCafpa0cGA/yhr9qkmw6V2ZF7O0fHTgEeZz92IUawWoyxM2MEt7p/Vq/KxaaME1bIg==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.20";
        hash = "sha512-WuVdo2synp6FvgdG/lqPQJFyV0ibLWG5ikhuHnnBbVrJOkynE0rTwvlFVTzXs5CgSw9ofH6LJ4YfvkboeYMALw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.20";
        hash = "sha512-HjcFldgON2envFBavS5IBWrW6u1ndumxZfXjI0ka1m7GWVwfKR22y2i0uQyc8uIKecwS1oSM2rzOoQqE7zBcUg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.20";
        hash = "sha512-u8n56IOjhI8pLnsnZU7snwu3asbNvCyQN+8/HP7Sjyb5GaSpQ5YY37vtqT5CJbXI5BZ3LoycuVujeY13IkkzfQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.20";
        hash = "sha512-RocDCVAwkTzWSju0emSAYEKZ4CnyrluOmTz8slUoWC8CPaCimKQ+uNrCk6dEO7GvgNZmsoLIE+Y/GIEKn11bJA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.20";
        hash = "sha512-hK9c+Frtcfz+UcY04CPx9Ji6/WMrxXnliocE0Uy4En3h+Vh4nh3CkyiLB63YJMVeK/ciEA/DeW37kS6EnU//Iw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.20";
        hash = "sha512-2pZT34uxcX3EwCbtoxMXT3NfOlZ1LXXWPJxfkfRhiBD0kLqKyTZnrnr1fr445NI7MD1pGu+JxbbKIhshqnaQ9w==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.20";
        hash = "sha512-nqn57h9XUlSImjGAZKAehRRCYe+NPYTJrvVy1EowfRBtz5erV8Bmyna23m2FcY5/JlvNZL2wKTByxsqsiKOq8w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.20";
        hash = "sha512-EeZ6KivP6+oTXjkRuSTCSRcRhfZPpFjqZ8o8oaxVjySeJDGb5nOtL0ligsxNMH3UaKQNIJXHzsvV+XAXP8zJzQ==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.20";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.20";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.20/aspnetcore-runtime-9.0.20-linux-arm64.tar.gz";
        hash = "sha512-Xr5NTne1u9IA7cYZCFSk0tV34i3lhbOkU7zL9AEM5dxaz7lR6ny/UAnwmfI6icinIf7TlhxdarkkhnTfShOszA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.20/aspnetcore-runtime-9.0.20-linux-x64.tar.gz";
        hash = "sha512-EdzlDsWhydqyFtqo11TMFKOrH1C6Dn6gzzCVxDdF9fLCIxnW6X6ulzq/C58uKiYjKVm4TEgUmg9hBuSvcHPeLg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.20/aspnetcore-runtime-9.0.20-osx-arm64.tar.gz";
        hash = "sha512-t8908hCQSsHgmxWjE/v1lms3U3jMh2LxVQKl6BhXcHGJFeJsjlmzLIKUcB1UtJZsZ3qcQUx8L6CkDh8nMTDIhQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.20/aspnetcore-runtime-9.0.20-osx-x64.tar.gz";
        hash = "sha512-CGt32FFRLMdQY3pMUSyqzHj4fOhL6J14laD9i1wiUzu01/CYDc0z1p5/3qoQbKjfSGDaPEn+nhELQ5xpFjCm2w==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.20";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.20/dotnet-runtime-9.0.20-linux-arm64.tar.gz";
        hash = "sha512-c+JzbeGMhOHlqrcYcv2NSL9Yv37h94GigIkwjbjX0/MJcANHr9tM4+eVmipsxUsNHkblqkzxTZ2H6g0qRJb1iQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.20/dotnet-runtime-9.0.20-linux-x64.tar.gz";
        hash = "sha512-qqY+kVb8ydHFHhX7OOPFOIp3Ie8bZAZciGWwMTOQbp3pZ64zkDwZjGrLmqi7rjc+kAFAUHQAnC7yoLtuVLUJpQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.20/dotnet-runtime-9.0.20-osx-arm64.tar.gz";
        hash = "sha512-W7Z2tbrCZW636MhHUyUFAHshVN8PZoLjGxaB410bdXyiAVWWd8fiuxl6a3VjvFhNf877JjRKn48qOQtBE2onAg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.20/dotnet-runtime-9.0.20-osx-x64.tar.gz";
        hash = "sha512-tjPjbzCvQNH4EU5uN3+TVRKGEF/0u5+IcTVVmDOZ7bp8yiHse4b3Smwd67iYyOxj7NshSziGbFa2P6w/+MP9Ag==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.121";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.121/dotnet-sdk-9.0.121-linux-arm64.tar.gz";
        hash = "sha512-LIKIVo2YJzcdjQ2vBXhZCpVtlVvveDvxQDlT+KgWhR8DvnqjZrZknnzad6jnNZrD/Eb6yH8BDXG250FalFet1Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.121/dotnet-sdk-9.0.121-linux-x64.tar.gz";
        hash = "sha512-1m8mCbUJpO7OStjvusSeY86ljgdlLx2t7XK70QDXD21dWKm5W5I14VjLexp3mVMRl57E3fLfTGowF9SnHxY3eA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.121/dotnet-sdk-9.0.121-osx-arm64.tar.gz";
        hash = "sha512-bjSq9dvx5ITL6UsIi8Jc+2b+IOjN9aFBsEccoVAj4Ig+BWPaO7aAQSaK0/wldUn5AQ7gReHRD5tlglbokvldLw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.121/dotnet-sdk-9.0.121-osx-x64.tar.gz";
        hash = "sha512-7HEHnrSWczmgfpZxXucljIqQfMaoNLdV/qwdgiRuS2GhSEb1q0OXY3PAjGATbU7HwUSlVN6C5ZWBIId4WNRxyA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk = sdk_9_0;

  sdk_9_0 = sdk_9_0_1xx;
}
