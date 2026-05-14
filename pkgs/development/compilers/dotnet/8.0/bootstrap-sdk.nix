{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.25";
      hash = "sha512-VRGk7HT6e1UzccMH1iNcc3r+8NttP1XyZFDeXwQRc5833AkkOpfR2WW91muK6ksC+0EKOaVAJEhmWDT4IalKhA==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.25";
        hash = "sha512-0cmoZ6fj2gbWhC1LP5XIpEXwQzlsqWlDFpxjUgwv/pVLe9HPeJWt5Q8Rqui3RO1QNE2CLqrMoWxI85b/apKScQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.25";
        hash = "sha512-BkKYjJoeBKLKfYHhmqIDhJ3tHlQ9wwDAq7NskffCgkaJh4IlCBMCWUDXmr1nNOW8NxaONioD2O0tBZ6KhzQ/5Q==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.25";
        hash = "sha512-rr6lj09G6Mk3P8n93Aa7XGHJ/2XchaKgF8V7QtFgfLWeIUdjNVzq8him26sOQGKtaMXn/hLkFEyweu8carA8Aw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.25";
        hash = "sha512-k7mqLNAJItPKfPPOnoPI2p6cpjfslWkKk+8KkWSPhsJRMKnR7/8e3f8y5/ToZ0oEfylxyOoGu1SFE62eMzfYDw==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.25";
        hash = "sha512-7Qa7XvKR9VSBFk1dllIs395MQ4Gxl0RJqk6cyBAlG1PpIq3kju+4u01ug7C4eJGcVcjmzRMZO8YIYRtpyN9pdw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.25";
        hash = "sha512-nFnoLX+jwF4HXUC4Jry2mK6BBzbm2LTGw38LyhqFRzcEpe8sfNsihXlHx+d+XKnDy/axQangzRi4C2LZ0Kg+2w==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.25";
        hash = "sha512-s6WnkKOwSSD1HDmQGrk/VOEy2JH0qUMp442bc0MAMLdzvZOLp3ETS7zObJ2kBmB9TqHEjzcybCjsNbApoLDLFQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.25";
        hash = "sha512-XJTKpxcUhrLt7TaoBELOb1iQUFYICtakHa5pK2vTTgcsb6GpVxYFvzyJDPDEbMdK9s6/iyKysWi1o/MUAE3qKQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.25";
        hash = "sha512-9l5Gtkz1kOH+cLgUDnmYDoIXB75lIQ39vp/6DlyRxm7PqNLBP3PXuNNHnGJ/cyvy5nER6DExV45HCi5A1aKr/w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.25";
        hash = "sha512-UcgDIJx4+Zh3yNrnwDJoXlA9IpugIUDp0niYFyw/U18c9jI4MT51YGLGlI7vy7IkOVA7O0mJcLABrABLKlcKbg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.25";
        hash = "sha512-c0jEySkvlVvHmH1Cst9CK/1heZt20GRwOfItWm4ng513VEfu0EbbJ1Z2UYxgBOvDruCdLv0z+lLbS1yxZdsyHA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.25";
        hash = "sha512-iufUmvbhlMAtLdFwCU1LFA17fFbhE/eYg6dLVxmPxvwPDVEyOoJqdlWQAH4vvOh8A2gTbEG56qSSWDKmUuq37g==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.25";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.25";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.25/aspnetcore-runtime-8.0.25-linux-arm64.tar.gz";
        hash = "sha512-Zdixa775DETarJBqr5KBj0OoSCGR2/PyC93N0a1gd9F7YXg2S9CCSVAd3TAhpMj1+YocA2DhJocNsUzwbNEnJw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.25/aspnetcore-runtime-8.0.25-linux-x64.tar.gz";
        hash = "sha512-3bZqw2YlKrOCJxJBs+U6dSAdLISMnshwon+xeKbbGOTZSbmJaj2FMNA9JV9P1R1jU2e+3aPZ88Z3y1lnhNvLnA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.25/aspnetcore-runtime-8.0.25-osx-arm64.tar.gz";
        hash = "sha512-J4g4l5Dea2BPrvUsV4WewpStGYzV3ZuMSu0VoVy4E3ywUgPBdFaCeSZXPc1mvGOqyM7gXSg9hoZ2BC1HNZMjIA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.25/aspnetcore-runtime-8.0.25-osx-x64.tar.gz";
        hash = "sha512-8SDaBLm08NnoXr7onX08bTk9f69j60P7G/GQ0GShpShg0DIiBbKjhz+3yBcO12aQiU5nU7T8JoxHzG9LfKuEIA==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.25";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.25/dotnet-runtime-8.0.25-linux-arm64.tar.gz";
        hash = "sha512-7tI/mVisrdxuS4OO7XX9M9LFzWb8Z9CWoFxgvMiDWYKInSxVlHytxHybz8PaRl0wf3oD4NOrZoKxYiM6s7Xcpw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.25/dotnet-runtime-8.0.25-linux-x64.tar.gz";
        hash = "sha512-pd4hhX/lFp7HjHBMcWOp1kh6dVOWZRwkEtJC/8JhTHVxGGysTDtOTJnnvfcWZ20opZ1JmGLGpv17gYDR45lzgw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.25/dotnet-runtime-8.0.25-osx-arm64.tar.gz";
        hash = "sha512-0gNqLlM+aIoVFkNJPCVIg6lV1U5QnjDLuHuQl/eMpMNu4rgDoDEM1XGwjJqFxpRQTyZcD4iE+bDHmNx0n80cow==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.25/dotnet-runtime-8.0.25-osx-x64.tar.gz";
        hash = "sha512-zWs+7FPz7wHDudJCgA7cMltEAVLLMkxwo4DZwhjQkYRp3R+eaOVYg/q8cQ0k8BrOEpubIGiGJqJJcK/N8IR0Nw==";
      };
    };
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.125";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.125/dotnet-sdk-8.0.125-linux-arm64.tar.gz";
        hash = "sha512-sbLwkjJUAcwxK0Enb1DhiLAin2+HQgxkjRqwXahtxAe8koqblTztFad5z8r+6eNPCACUE1aLA5nHJ/i/cbccvA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.125/dotnet-sdk-8.0.125-linux-x64.tar.gz";
        hash = "sha512-KXOFSrkK9U8sYmqAMvTftBv+3Vkh8dW5pLaDKJJ+eF5ciqaT0k9zkwTKRtmk9ahAgfqUuEUuH0+DBAqOWCorNw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.125/dotnet-sdk-8.0.125-osx-arm64.tar.gz";
        hash = "sha512-9qxDRPN0NM4U/JiPT756O5LfScjQdXjHBLFBX0BBArCi6kSzmJV570Pi3njluMJSOtMFDya9PrHDGHwnyEAOmA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.125/dotnet-sdk-8.0.125-osx-x64.tar.gz";
        hash = "sha512-t/EJptjfZlMh4HV1TJjn4jTzPe7DeWolEC1wvHZ1UWDf6KoLHjiTE0U/VGPzC8G8+EGZcMAamR754YF57dD2pA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk = sdk_8_0;

  sdk_8_0 = sdk_8_0_1xx;
}
