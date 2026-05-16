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
      version = "11.0.0-preview.3.26207.106";
      hash = "sha512-R0oOS+lwsTaHWnnvA4dBR3tW0DYczn+UZJzZ8VIrnv0NAvfsVtWmFZTW1RGm+5EMl9WcESvbwTdxtN457OfINA==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-vXKuBO0i9nUi9uZbtEl3henxyik4SsWJwjTV5Qwz3W0OcE60wc7vAGiS5mpp/ri8imRoOOwqHv7LOWMwVquCLA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-a64GvXhuEc4ivI6jI0tgAllXmkhxMUdTZgkfH5VmMpuQqltqYFj/c3HeJp9yeCX0fqO8dRVzeFshWHnEoJk3KA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-vBJCIWQCfLS2IBJO7fy2OaADC7nG1GF6lUeJVpZQkjFJaT7NsvNBVV9o7h6lSoP5I0jK7Wi/CY0gJ3fF84wEsw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-G6RhMVU6MAMvYAy9Eoq5d+bOQ4aNFslQTit7h3ejwyBumR8jJ4La+ck2CVunYhzWq5W0nzYzRKDr9VXIRKZW7w==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-6Qh5ssxzcqrDlgI8EDs50xdkMSk8QRNCvGzF4pf2PJKrDRwf/JWJZuVhzD9VnUQYj4FT7k2K5E++zTWfmeqjXg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-v7xwwXjh9DeLO61O4Zg3kbuz3WOhlWssK0bgJ+nqe87IYNw4ky4aQy7OtO9WlASyMA1FB5kr3FUg5nNrkZVpjQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-S8gEsYiwDhFSFVI+pWt8x7fNYYAuYbnb1jevZRUYYh2oKyJtmDqMJmC6wOoppzEFO7qnkYOOrhpEabbeKJsmZQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-tqmapfWDTNsoVsZD/qFjt9YTnurI2Yk+MRN1O9Imzm50H2xLbcZ+REeozRaetoTJkNjjOqnlnQsBgeFuRLQzpQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-6Wx7R8lAJH9+STlTmhvkeyOPTHwtL88boOFzXBWykV0v0yypzdFvdOfjAvf86zSW5mSQMY147yATjckSE3q2gg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-mL6CWnO7yosgKNrzCOinLs7ty0UUipr1uRqRjk6qjm8X4tpGAedjjUtarEmXWT6Z9WA1DUNt8GpXnqIthJchRA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-FfDI3F7L8vT15tzaubmNYc94APhUfDQFfOaKsBuvcgBiyVaM9qdN7shTH1zbW85pTE3m1G0zvVpGC80Z7y7PYg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-45PH1vwghcp6ffZ6sV7PPsJw6AHWqC4wEwydh2cxwiikY+OmWAFeSpAAPAjY22zJ7Xo0F1s4+AO66y4CtrUaOw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-k39ojqAMM5zpLrrM70KhDN5dVMkPuaaNDEQqxD/5BIzx8sXH5q3m9wyxhPAjEqE6gNESSuMNUroxLz7U5e+4AQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-OTDRYrIgu1WN6Yy+Jb43gSdNMhUF4dXSkOi8pqUfJFn8MH6lHtJfGYSa0KrE61jWwKKUWdXLAx42Gpne2oonOQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-flnO+/DUeZE9SUmkyIlMsZrvVomX8eshmKUxzYgO+E31TazXiXwvA1J7unq86gQVXlrmoV7xutlFVET56UmMBg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-RVOrXi8vm+AB/6Ma3kO3cOTpMxg/B6td8edIeiu96XyrOB43HhoNc4KLJYt3//2Zj92sBip3QZhOB66+XvWMbw==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-cqn+9UZlNhkzywCde0Qnn64+DvrneOw63CGt2l49gIlPpROoy3XZ4NxpsSAq2coyeFYzYCc4Yt5zym0Sw4MTfA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-FMwUBAikT2x1waTYFb5BmDqM6l+5u3DUkcLcGUeQRXUlp49llUjDPJ7lNgi2RbWoDKlNGk1uaMs4+TfDzCsdJA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-uy0CwGFb9UBJyud3t9DTNTohncZKKxaL0adsA+/sQ1lRt88qv6fZlOfWj3zH+s9H8RlreDQNmnWVp0R7Ooqb1w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-1aPEbl8CyJK+JaSKp5aKGXTptfU+4MqLN1cKeXehibb+ujjrOnsaaDbS2z24l8ygCSSbgiWNtc0AtWoKzGl5Tw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-hBWzZdGL4XCxxsJ+mL9il/UZeCe1F/p8ifC46u4GpW/r+13LWdxm9DA6Gd9A/gX5IfltOE1CxWZoG8EXP1J5ug==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-3UNG8Dpxb3efcwjFkkA4Nll4tYuEsuSG0EV59yVBMWmWDQlqaYvtDHENNCsqpUWtCcRP7ovre5jVQMi0mC9+JQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-yGn04OHjVBBHhbutZdPGYjWIKHV7ezRBKheeeXB0739reyAGH2H0RbGvTN8jgjiUznUku/3os7h5xvq0sxb5Xw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.3.26207.106";
        hash = "sha512-6X+HPPT/dFsr5a98MsB98F2jrN4aGOAHCbGWyvaY7uyGJpoODgozPd0BiRHZqi6fHRn/ykEijsoBss9VDqYIfA==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0-preview.3";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0-preview.3.26207.106";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.3.26207.106/aspnetcore-runtime-11.0.0-preview.3.26207.106-linux-arm64.tar.gz";
        hash = "sha512-7wbJJQgr5bxq0P7AqzPP5HlfltWuJT35MOfM/6AXZD7cYlwn/C0mGeaU+bv2eOQxq51hQ2KqYW6PwYyORNbDHA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.3.26207.106/aspnetcore-runtime-11.0.0-preview.3.26207.106-linux-x64.tar.gz";
        hash = "sha512-YWlN4Oj3rExdqgOmo+2/mSQana5j2cAhU9kd+d9Fs/2y1UEgMNblL1LCdYLWNq2Ra1T/iadXjecka3c7/XZMBg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.3.26207.106/aspnetcore-runtime-11.0.0-preview.3.26207.106-osx-arm64.tar.gz";
        hash = "sha512-chpOHW7SSvTiMoiXzFYgbXrri1hL8irvHQrhE44vKpYk1U40uIam2QHTnvylhtbptzA02EZmfjQ7NURXUeDgJA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.3.26207.106/aspnetcore-runtime-11.0.0-preview.3.26207.106-osx-x64.tar.gz";
        hash = "sha512-q1Sr28wzzVdPMh56SKh6EiHz4v6ShpTtAFPhZHXqCqywiRyDkpKt8DrK+bTzJyl/+fupvF5ufIX1lXjF5rch+A==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0-preview.3.26207.106";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.3.26207.106/dotnet-runtime-11.0.0-preview.3.26207.106-linux-arm64.tar.gz";
        hash = "sha512-QTXXbJGgJGjO3FnJrHV7C+2x9Yk5F2Aq/d4qJiIaG4KP2q7+92SomqUyAR3Pv3hEc7d0DJK5lF+RJiV8MoSWnQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.3.26207.106/dotnet-runtime-11.0.0-preview.3.26207.106-linux-x64.tar.gz";
        hash = "sha512-Qk3G2hG1tq0phI/qocAV2jRIqAr0q5U4MqjwUifK+LFtbvxPADtnXkfrI3ugXxVEBlUGye433ZnnAfXf1eCfOg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.3.26207.106/dotnet-runtime-11.0.0-preview.3.26207.106-osx-arm64.tar.gz";
        hash = "sha512-h8DGOlCEbb1uuzXtXlcD0fag7xGEXbe9lAFORo9UcmaAbDQMSE0bagy0VwCdlaK47gR/fbEdqQ8Nz4TygTy+0A==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.3.26207.106/dotnet-runtime-11.0.0-preview.3.26207.106-osx-x64.tar.gz";
        hash = "sha512-vrGy7EPCRHRPD42q0Z1iLtqGrKVbE1LyUVOjf11olNBVDeqsUIFS0PP0qbKXypZX9eIJ5hZ5xZ5A+gZAMqkL7g==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100-preview.3.26207.106";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.3.26207.106/dotnet-sdk-11.0.100-preview.3.26207.106-linux-arm64.tar.gz";
        hash = "sha512-lgL0cIMGlW2QJ39uydsJWDprRnpZWIuo+pWZQODCVZek5YUMP7xcUzvJxh/DxTMJsl5GSNii+ynFDrDfRlO4iA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.3.26207.106/dotnet-sdk-11.0.100-preview.3.26207.106-linux-x64.tar.gz";
        hash = "sha512-A6nmiA7NBzAaKuleTr6gDfdYqAhDaDyjo1xGFd8ySTE5/KjDuCCiKF6xVY7HGS39AIFlYIndDSJhOL3GuY5SGg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.3.26207.106/dotnet-sdk-11.0.100-preview.3.26207.106-osx-arm64.tar.gz";
        hash = "sha512-whvgDXbhNV4fiNXn94aBPpe1Yf2MwQQ1b86ic8hVOJ1Ccsjz4n3g8Ne3WVafLHg9QtGUWQ/6lZxGo//4MXRhlw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.3.26207.106/dotnet-sdk-11.0.100-preview.3.26207.106-osx-x64.tar.gz";
        hash = "sha512-A21Dhd/gYrwrI4URqEKslaFGJvZEAh6nkTEjs8dwgaOIzBWMtU3pYC1VAkSeQVm/TBGoYQalwSlEZWSW3jV6jg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk = sdk_11_0;

  sdk_11_0 = sdk_11_0_1xx;
}
