{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v11.0 (preview)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "11.0.0-preview.5.26302.115";
      hash = "sha512-QhvtL8dNIZ8AdqPaAtu/nKWSYIK+6H9A4/W1Ga5kw9T8qx7I+DtGfeNZtFBqos7m1Lub3s0k6Wrg/ZwV05sRaQ==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-QN3pGDNWhfBszzDgoXtYiN2hvr6+/Orjdm9xcurMMSdqXkopIhFLYxMpfQYUZfh9wlP1YvNpahAMICTbu5HmvQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-snlURZrRW/mC91Qy8tm0sFaIgVD++NueoA7fjREDcKjR0n8LHOq/oK5U1jskiqIp3gMXdihYP+bxcosq72T0Iw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-vjaA0BwfcMyiusm+1HbwftBGO6SmnIAUbq/cYf+yxoksl41MYZ0J2VWzAH8S5zHDvP2NpANZmA1mtyjiGjMPhQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-fAV0nf7UM1PEDkt17gk8x7Wkn6PekhbFWHL0RM0HyHFU9dkttI7X5jk0eOLtFWnSuJ6J3Bnw3eRicea/BH0rUQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-T7uv0WCDDV/TbgoXAGs7ISO8C4XY1W4UUVQHeafncwWYS3UXI45sDQJ1CtTH9iu6dip3laTQP7ulTse4I2hbWQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-J968HBEwpqUReo6tPY2gFZmbP3QZmh4MjE3YuBG7BOkNlHEooQfK6xFXvGtcCrzNLdXnEoIIJraoFZ6Q5pDYhg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-YgboB9ugdS+mgA4ROUGWb3fs8LtksvwJ33YUV8ncVCLgKmP9WLVvshl95XAVNAbPSUmpLaFW01dG6ipAKM6Qlw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-M0AMDxwNGXl56MCQJcz+AYlCffC/n5TuFkePhJ6Ku1v4JMQZi6FHPEcOYCbCLiiopPRFurWLYTgViivb9FJaHA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-vxS7OGgyQqbhg2UMM7+SeonVfbciQVO7lwZDjhXEFWs4dp17gR/qtMUFSaZ25Pxp0jEcjrv36fKuHUuwsF/yJQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-prq974j2au5K/5wgVTkwPsiycr9hbdP/Lu8exkE041yVpDh3rXiRRkQFzYIE0znuhdKn8ACRauW4+Qc0Vz3P4g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-i8LhWYzY4m5VHAGBtticCasPtuEFmSltxE3dA2IFNE0LtAwF8B2KOs6KSjuxBk4ZO4V3//Jz14IuQRP4T+FlZw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-7Qvf/Oi7eidbLPTaFPZ9QxG3uFylfwrg5IBj2f2IdqWMcLZTMu4yV/VwFuvm8SYcQ3vCvjgtyq84GB+ZPsBQ0g==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-E0cyuRwIE/c9NAvye3jEE/6zX99AhRnVI3Rfo2ESP26bLEtk5+rcFj5ExQ0dM9XWxfVmJZadi5iUWfu28z4KqA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-SwNidGs5xMNfyl5MZgnP0ZDigKik7c3RlqM/mkDpDUu4uRSU7IWjL21E8hz97tiWCNb2vdyxEjSmZBT3dgH3Ow==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-30mHuR2oQoVaX/tK/Emn4fm8BpypjhUGEwwK31P0HB7Maw2HlUytkDY5wVD8XL0BPGMqXvrm6W1z8+u0tC3yRQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-arbobGEm7VrH9NcSsBEYrlBBLjU6DWwj7eRJZ+R555uhhQLl2QFMvC2Ml+ZHAZEhGikiZDsnAQv+lBE0OZS2JQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-Dr+Q6HaY17FkgE+d7pUH32Qg9kTwgQxmkOIJtvGPbW5f2YEJo9fympPpuDle6J2Ugc3FXE50Ps8/mtJWKLEA8w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-cY83JPcamX+C63hP3JI7ZC2+zCT4Gl/qBSUb7ORrdkmKaTKwf0B+0OLOqrv8lZBZRJNizE6We98qAny3wmHBKA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-6AFRIb+J354hGOarw6VQ1pnXS+YT0lW4MHKFsOV/GdBQUqbIuv9YLADWMtICNk18kqjzrwOKimG/Dkn14KSiEA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-kKd/sxnzRZuFFR1a/dmUzJ499/u3LcJL5tZJKMuqPAZ5XZyCoHyscNYvIFL7R8PA2v4DKLI8wZM7Obbe7qMoLQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-7WM98tSzleNfsYOdLvpc2rfGoa84zMBkniev7OZj8ncLtiBoil5Qx94CUJbRxbQFZW8j3SJBSg9s8mOhpHYg1A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-gx+7kVwc8ss60jqk/z1t1YEbyCgjejVy+f4CX5uZLbOCYgqTuY2Yhyp+A3kSvlzXT9dYgRGQsR09tmldG16LYg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-CpGRxZBZl/LNFIe11nzjykXJSGIbLWoZGCOn65IC0NhjvfmrTxk+TzfqkeodBNf+kJvqW2hTL1lTreqQbOvKrw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-QDozJWDVUn7rVBDvivPwTdFdhxEKNVhJzZaz4HSJyemWznHnn748eBLmix3+oBB2/PCz/IOs65NjNHmxDskEzg==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0-preview.5";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0-preview.5.26302.115";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.5.26302.115/aspnetcore-runtime-11.0.0-preview.5.26302.115-linux-arm64.tar.gz";
        hash = "sha512-KytVBb87U7MoAXDwzMBaXrcywnhXw1C2r1dxWr9UQu53sGvzGdbQTlki8VCovlJTr1r073koMDuGWit6MQwzTQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.5.26302.115/aspnetcore-runtime-11.0.0-preview.5.26302.115-linux-x64.tar.gz";
        hash = "sha512-caC4T47bdh6oE1hx5fZHaFdmI0l663Fkky3AaKbpsa+pvLXHY2If2/B9np9rggIzIWDCXSuXtL//PH4zzISNwg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.5.26302.115/aspnetcore-runtime-11.0.0-preview.5.26302.115-osx-arm64.tar.gz";
        hash = "sha512-3AgtDYs8vbWlQy75/6RU6EOmdU9P2zxCe96PXfr5KojHwjVYMwGKA0m25qcfWcCLdQzOtDqhRiYGXxT2EqVW4g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.5.26302.115/aspnetcore-runtime-11.0.0-preview.5.26302.115-osx-x64.tar.gz";
        hash = "sha512-R5KG27s8O0+D+NHxOwy3s82Ibi18YoZnKtbCwRquAvZlwHSoo8ltAhf4by5TBIxwrk7FZeuy5dx8RpT1HPY0kQ==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0-preview.5.26302.115";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.5.26302.115/dotnet-runtime-11.0.0-preview.5.26302.115-linux-arm64.tar.gz";
        hash = "sha512-YFcHwqNOvDnL47hXQs2MOdcAhAHkJ7Iz9zRJcOM8EpC1Xds871HpiTKjnhb+frMBMtDO4tDGvJLujrhfrmo31w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.5.26302.115/dotnet-runtime-11.0.0-preview.5.26302.115-linux-x64.tar.gz";
        hash = "sha512-34Rag66ck4knFYNkK4N0eZDJWOv/n4yAj3oZX7eK8M3y5vmNVeG0K1dmQ+OjpULm99mKI0JQbyFraWBCLz+ZUQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.5.26302.115/dotnet-runtime-11.0.0-preview.5.26302.115-osx-arm64.tar.gz";
        hash = "sha512-llr/5a1kNM9FtraO26ceGqiWB/+Ji+chATkyK4nEIHFyRhyn9tDWMuxPywpU9tXUVBfo9ztemk2dYPsawpR2OA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.5.26302.115/dotnet-runtime-11.0.0-preview.5.26302.115-osx-x64.tar.gz";
        hash = "sha512-eZpF5julkFJoc+TQ5dZ7gXb+2wTXcT55B4YGj66WdP8PC1oUWmRqo1aHvkII+5UJ+a/CqLsbph+RUucZ4DzO4Q==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100-preview.5.26302.115";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.5.26302.115/dotnet-sdk-11.0.100-preview.5.26302.115-linux-arm64.tar.gz";
        hash = "sha512-f8cw3FmSZRfsxKp2hm58YvUPxzMfCxJ8nXeJOnFpHb5XYmXfX4Qgikz3jmxtF3XNCS2+BcnpxQrwF7s9yUct0A==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.5.26302.115/dotnet-sdk-11.0.100-preview.5.26302.115-linux-x64.tar.gz";
        hash = "sha512-nIk0A5iFjm41vbE3eg9cTYgUGp2tNzA2g8d/b9BJi2pLQ1o0h1r6oCEpg2IuyTeyO4sX41OEAfvb8jTSL4npFw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.5.26302.115/dotnet-sdk-11.0.100-preview.5.26302.115-osx-arm64.tar.gz";
        hash = "sha512-eftGDRYp9Rb0y19Yu/TV4u1pkLfeXz8Ru8dfKHEkWzmyxLlthjRkbDADX+vailEF4QCHgHi6L3R1/+sLCCOvGw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.5.26302.115/dotnet-sdk-11.0.100-preview.5.26302.115-osx-x64.tar.gz";
        hash = "sha512-/4QQgBRJ0nRhFzNV4W9BcGhLbJcGgjRfVwB8/qQ9Ze/VodliuYgW3hmqExn+DKLOdvMLKczi5N367bsxaQSbSg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk = sdk_11_0;

  sdk_11_0 = sdk_11_0_1xx;
}
