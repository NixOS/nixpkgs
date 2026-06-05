{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v7.0 (eol)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "7.0.20";
      hash = "sha512-ySX6TZFi1eSJj3c3JIroCLzHbZkLmr+fgeQ78AUYsOUhjKKw7qliqRoMKx9Uqc/qMMkyRpSBcwfJ7X7vWYbPeQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "7.0.20";
      hash = "sha512-zIPVUsCfS9EbdvNxJ0tkV7Insj7CTpIMA+ILK9y6Tr7qqG56sgMIW+0KOJg/UPlWH/2epqsIhMWoBZWt8bZtuA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "7.0.20";
      hash = "sha512-dk6z/ZqMpZ4lxVisgnPX1H+MwiUTRQHhwq3e9VMSIRL5loVdqHlZ9fRFfAejEz3U8EbvGV43Vp3OwF5R7mlTTw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "7.0.20";
      hash = "sha512-H4RtRdwUQpBk7tJFT3C/c9WNGGdAVDq9S3Mz6qYP5Sasov7NPcR2rkoTNIoo4jTt3p26vsNcb5lAiQBBptaveA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "7.0.20";
      hash = "sha512-puv59sewO3+HudFk/Fpt8x3IJuEDk5TvTSJdn/EM00P8j5AmA3WyjHA1bSSUOuyGwjxPDe9t5iYoaYDysa97mw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "7.0.20";
      hash = "sha512-7xdJGNmwiuEV8vRizwuX34ETFRuxNZZk4t+o8JmGrGDecZ1JNgzip8CUz44/AYaLztUdXv3O7xZB7OQO8AO5Kg==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "7.0.20";
      hash = "sha512-4WZbJ4WKpN7BzXKIQhzNz3Srp3zhDHiv98SFGQlAzFiYp+viQ6nzD4jzax9yOkx6mDCuOsJfscEq2U/pXL+2dw==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "7.0.20";
        hash = "sha512-GJMG2UNQPuSxxStN/x1Seee4JUXwhYmn4h6/dV7xuCg7zexC6S350W5GEBqKc1kU92rD2oV75UdUkqZGimU4ug==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "7.0.20";
        hash = "sha512-hR6BQ19osMSIzMMaBC/XF9VU4yKhjjAwEp9nEBwNmOrAQfkVRwG5Td+gLhRiOMW0pY5/GjXLlwziiFQ2ksZqaQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "7.0.20";
        hash = "sha512-oGiO7TutJZb4JVoPyqGLMaDQ9oWMYg6rp+dughnnNhD4bU3xy189hWfxfMYTHZbct2vlPbSX1OlTCkhjENgpww==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "7.0.20";
        hash = "sha512-Ydi2yUhYl//LrXMYWtr4YKxwbz/M+qNI4VJG1zgLRBBu2ZLvHULKOMMtiUJYYHV692jbkENGGFUUu3E6JiCrYQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "7.0.20";
        hash = "sha512-sOSigEu2JZ8SuVT/34zUHiw0xiDxjsX+pRvbvXa8aXWAJwfy/CFOow2S7wD6foZA/WCg0wPeaV3ny8vWE8Nt1g==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "7.0.20";
        hash = "sha512-s1fmr6tneGoM1Kx6Bd3ZXHpCBP5L24uZStqZpstEamz9SLzWAYouDgclk2hS1vrxkTEbM3tzHUtMPzBGaB0FWg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "7.0.20";
        hash = "sha512-O1I5IR+Bn3zADNEc3H6mG48hW934vx6qDb09UlBVuDHlOjkQorm99IEktZZNaWxcuOqhtEi8+1eIAVmyBy3maw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "7.0.20";
        hash = "sha512-Cf37Af+mBJseV7N6gV1mVPVu5ldPF9jkQUsu+EZNwDCrzKLslkQz06E3UiEIM3LHWh/TtIYZe393Y7M7OwKUQA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "7.0.20";
        hash = "sha512-3yOYRm4dt6x8CM9xQ153CVLQc/f5tWJSKs6t/Shq9Q8E4kE0S1hYP3i90zorOlrvwHO08wcb8pxYOo2l6PPYxw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "7.0.20";
        hash = "sha512-GYaw401lDpfW87lbZzoLiZmEG+WjCXnxkEfFi4Gs8+5YHZBAxJLV67r4ifCGt0n/TdXbxDZbZCXBT/lLzij8Pg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "7.0.20";
        hash = "sha512-Qzruh84k89DwZQaHiIrK5WqRD+ScoNGbX0xvG1d5OPO0fnJod/nmPhdYo/9AXobTpY9WYpfEVTcGGMjGncwfMg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "7.0.20";
        hash = "sha512-H2xNMKpVvdUDRDGnEecDq84wPWhhjL+ls4W6QUOGwp6hoSMDOIXqUMPKm7gYlO4O0VCy93DYXx5aRXf9tVMVlA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "7.0.20";
        hash = "sha512-sa86jqaVkMxX80lCyNczLAs7MlIp6ZEba7kdWL3WUviPzfG38NT+KGuG4ruV0NEQZSIlrCrQzeu6iHhirIhDhA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "7.0.20";
        hash = "sha512-jbKk+MEWwNJ4l/ueJ8xoc/WOAnYawTohaMuRI67dMMldbsFMjtjNJXBqANioRgEJ/6648fiysvgat39io0KlBQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "7.0.20";
        hash = "sha512-38BRd1Vma9n8ggDVTJOVgJwNvLhnwvy3fOgdeLeDtwtEZ1QhE+CAgQwzuH6VNi8H10WGCP9D18f1+dw+/Wegnw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "7.0.20";
        hash = "sha512-3xM+swE86Z5Adp4LM+CeadMROSgoCdQ3i+aiiwKv5JwXESeN/1cFQgIJjuXtZAmSeaop3eu64Om1+poD2YtWbA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "7.0.20";
        hash = "sha512-aoVzNoDMrYlaBnBqsdXzpHFgzPR88j5foFnqa9w2VWyeQqqSxvBv7PCOc7yWSU+2yr5tIIr4fa1h8Ahn4+9uZQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "7.0.20";
        hash = "sha512-/ikA96hY3FQhOkrO7lcWmlry8e2Dq0gvDMSJ5M8A7lFFTshHL8+maXxitWXb/JGRWmA2F7s8NlIkUZOXmblV3Q==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "7.0.20";
        hash = "sha512-XHwBlrABxZA5+Fny0zs0gQa8OLHqWU2dCT5gtj0B3O9B5696yiH0WjSu4Af1cf9q9zBTfVOPkVh4h5etf3VUOg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "7.0.20";
        hash = "sha512-c+P8/CGPeinx/ch69USopX0t4nux/JvSExuJzhlcgNoraYWJd+qfR44qZN0gdYBKIwCPem/xATze8FwxKcG4cQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "7.0.20";
        hash = "sha512-y9Egnw0qVXdKRNOPKZ0amu0B0ojk95f838nEmt0A0jGyTXHHo5uXCK+DOGH7pCbeiaaZifWo5Va8CtDXSH64Qg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.20";
        hash = "sha512-XhbUBpTDP+MVdtwLWCcTRJlhuJBHQYMvDpBAt5TvSlkZgUNeTnGTKGRjaehrA9refSi440eYlR20fDONE3RcGg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "7.0.20";
        hash = "sha512-oRBtuytqfo8feMpWAIajol/mp0Q5clXtccQ5YiGDOvhf/OKzDquVKuLWXnoLUBPrz3wdJyfcPa/hGZZjbexKWQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.20";
        hash = "sha512-m7921DXQMDfqRICavvcOYnH+LEAS3JqE6+jOlI9lST624PLO8oWac0GrljwKkhA2QPPjNZEw8+QtACkiJ0KnYQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.20";
        hash = "sha512-JL9ppjzSerw1dmYJ1SDJ92Hfbg6G/kBRFZ3r0H+JMo0fjE03TSPmmMRPNbeaWbqeBLEOsoD9CnvVg6djdOEvTA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "7.0.20";
        hash = "sha512-V6EHnxIh8o/MG/VEtWYF5yKGB4ZoXZsgMg9oSfummwThV/qP4vclU68HtoINgpJsjl01/D6q2e9eccElLCPt0A==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "7.0.20";
        hash = "sha512-7alEgdaS+JmhsfvgZWcOGEOWfL20TFShwkbpbRtiyXjXzMV6JHVER8s3n+tV+Bep85ME+FRwZh21YK+Nx33aZg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "7.0.20";
        hash = "sha512-a+SvJNNVQMGWbTKKmDRS4Dc83WzP4REEk2doI3UjEMkFdsLbEm2Lep3vCUpb7mkkFvjYPMiFqNiNG6OGTuVaVA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "7.0.20";
        hash = "sha512-gxR7jFMvYM0IDe77zAE9OnCveUM5eW2poCOayo88FD82f//4/BK6sHY/gked0cu5cUMhygTmXEwr3klKrRnxgA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.20";
        hash = "sha512-4q9Mo/KPoOkeX2gvUbgIR5Oyo+YCozXFd0rLk1+uJrZabBrzyxqs1Wdx9Iya2KrM4b5X+rSqjEZcLPZ2h2KpEQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "7.0.20";
        hash = "sha512-wB7JHQS6vd0aRwFVsLGwzjMs4n6nmt/Z5EhmESdrOoFAtRm0e3UI8nerzUa+JGInlCrZ5RT+1VAtwNNoUJ1yEg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.20";
        hash = "sha512-krhZ6dclekB1enWxYcCeboGgk2yaJEBV5Cn5thj6Lv6KTMfpcqkIJobtAxcb6eg8qJVqRTN0DebTedR4lSFQKw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.20";
        hash = "sha512-2gAdw0/KO7sqhe4B5bcs++sJQhv5DlNK8QFXehXVjd3P8u2wse8nSuquN9iYi/P3ztnFaJAi5yJvzNEwF+fRQw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "7.0.20";
        hash = "sha512-s3xEcytFnFKyBXUWrh5GehbZ/kG5thQKn9Q6J1iNaigIEzxbaNO5vrtPSb0patwnrsltzHC7e1ETrkY6E9/jGA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "7.0.20";
        hash = "sha512-DC+IasSvYfnFkrcT3gnq08t0iVKmIPmxEFrvITw3qdwH9Y5kz9ZEI4xgcQBIbrzUcE+z/5rwWVhATcxNHgaAWw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "7.0.20";
        hash = "sha512-abPlEkse/tu8w/F9YPG7fzIP+NbtfhfBrkTjCgnRUnL+HXRkn7ysrUQJ63zWlhVYWilzwTAmUlnjqBsZ+Psnzg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "7.0.20";
        hash = "sha512-swLcwMoZuUvAWukwmEbjr+YXYtRyeDR/hiYALZ5SVFjtyfS/FSE3IY/xbVtkEyfMFPEcRdErlDVYcJEEq0kPaQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.20";
        hash = "sha512-6VO37nmADf3894eVUQDS2rK2+pNC2QMgWaeVrKL4iKexXDPqa8NC+Qy+FeU2j0Ugp3+V13WFrl1+MXDXIDflcg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "7.0.20";
        hash = "sha512-HMRw00L72Ey4bWder1PBZ9VePtd4pJThOMv2bobZrnwzav5s3dlgGjxYc1xxbhmUq0vRZVJrjNkjcM0sAVxIeA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.20";
        hash = "sha512-1CHk19oIgLW9RKP3LX8M7SoMhdYVsQP7nnA5iuKryGeBPvpGsxGcuB50nzQgUc++PfKfKS9CNPfVGrwKhGGo6g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.20";
        hash = "sha512-lKM4wOtXytPXxf6kQ+68Xmp2WNddKsnJw40MPuWgSYki2SnTccCaP/jI2s+9A78wqx2ycoSOhMTXM37Ee8v6wA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "7.0.20";
        hash = "sha512-Co4sV6mPzPF3nh5YFe5RMDmcW7x2nluyN9hAP5zBd4w0lmyeLRxc4BxUH6aq+vgtOjjoS96nV2p2c+zS/MSiZw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "7.0.20";
        hash = "sha512-MEK4A+6U5zcx4iE+D6iBWHoIX/kJSSUXlXMeWNfMrE8kz2y0Rzck5/zeIXyj39vPCJmuNgmkNqJ0Bd98k94sfg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "7.0.20";
        hash = "sha512-vLWNiWcEUx2WSIcM5U5kHDzxm+ITpE746cIzFc0IXY2UgLac2MNEMxmyNC+kI6rXYGwUEJwygIjZhugGanvDsA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "7.0.20";
        hash = "sha512-U0enhz5LmGi8FK4Zue36ikxFnoUeBM9nH3ZUmrnyWSYT9m5+wp8Bd8I6ubebW1j8K5d744I9b5oUnNWeGLVkow==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.20";
        hash = "sha512-+mXIZIE4bpGkhlJjBKKCBIm3dJzP4n4LXpsT5Kz3WuasxdNhJ5TVVthIuLz6KKoWEpuRyplrf/rJp0RU8FqmdA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "7.0.20";
        hash = "sha512-ywvN5Qmbl94w5ZEAllIpzfHbKLdrjDz626vnr1gaocQNE3BQOi2gt8v3KgOGxevGLrQOocJ+zb1U8GYmxl/g/Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.20";
        hash = "sha512-5HVoAWI+7YnneMvF5n62Hp0V45YKONOvHInBQ6gw9TP89Ykf1gjwEE6zQHlpu8+lX1qcTfqWu1iC/GOoo3BshA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.20";
        hash = "sha512-Ji7Q25uFyIEAk8/+4sOmPFDa1UQmnM9bv8ROtH91vyPCZ/RHxU7qo9APSqQAkkK64jHVIDe+BSM2jlowvoGMEg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "7.0.20";
        hash = "sha512-/Ht9KgYt/xsW8cgzCbvFjsjGElx24r55BVGsrQSA6VLJMRvrZLwU6lLFuY1x0CfF5ALs0Uva/jCxTtt+zggaYA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "7.0.20";
        hash = "sha512-bCcmlaXLBmlScQ/HXkkLf1DYQtOjqet/dI8y2sNx1hu89BwEQc28inzi24PZ9GjYo3KyKvy7U17aldK8b2uYAw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "7.0.20";
        hash = "sha512-4Ok+e3bc2OJ2YisrmLCMFXKZ/WD5Gyxchryl5clC4s2w2ci/kiDnKI83WL1ibNvEk5wIDRsrCQ5KXA7vYn8wyw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.20";
        hash = "sha512-itRU+NUtQU4Oe1o11E4jRkbR/DWYKn6XK52n3f50WyblkBk/wCj6C3fxZ6mMbXqcJhARy5p8X2Zs5sFJJmv43A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "7.0.20";
        hash = "sha512-IztYZXvLb2W4eC9foR4RFkGujR/LUdDx4UEh1Dab4ImDGj4qO4eZ7OnVCYUONTudFpLGakcQj7Faaq8rA0ye5g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.20";
        hash = "sha512-DfsYyPXF4XSnyvxsoPUsKc4S2hM3c11WxUGMJJoxuD/5AaMcaAvhkObqxXSfTXhUPHj4Jat7CxIqPMQatVLTcw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.20";
        hash = "sha512-/aMTfk42LwVNm6HxNk8ZR6yPPjIyDdNH5/zWs6uHdGL9/9U9Tx2P0ZaKmk9azt5NwDtWZqMpqyDVDb1HJbxyIg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "7.0.20";
        hash = "sha512-wh25bBNZosflPj2pcbIMB/fttuSFCvWn4N8XmDYd6XA91RpRk4GkZx505PmC+kpfU2FgM0N4zWgqnjcrifp6Ng==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "7.0.20";
        hash = "sha512-9k+5qHlL2/uiC5/crfn+Shv/93FV1E9oLFFK6nAs+/tUXL0olwsqpyEMUAdKdAoCgiTv50GnBjX/7jlp9bMmlg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "7.0.20";
        hash = "sha512-J/bFX9ai9i8S0ux0ZdnBhN+s+IFLosIBgnFvTBHuNfblPQ6R1YFsfYww5LQFI+plL8A2NcIdnBxLACrN22jwNQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.20";
        hash = "sha512-IAhdRGfxbYD1lF51SqBfDWIEvsysVWLPWELOpYPyY1CvmTPlGBh5QNanw2TLPu29eKb8k/peSVHJSOLKL8EF0w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "7.0.20";
        hash = "sha512-LuFx7q7tmDBcHce9C460IbL6Dp78jqsxUvSUC00XfB0D4uFhBVroWhHv4BPfFQ+cU3+/XEAOgW+H388kXuwEEA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.20";
        hash = "sha512-TexO+i9DBf7QLW+JVnraEDFa3/7szqJWq5jLOskvEUBn/jrC7rLodIBr9Xm9qYeyPy2K6b31oXmVlGkPplX8PQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.20";
        hash = "sha512-Y2Jlv9Eq2tk2V7cyHW2uqVDxFlDFwANAtp0Ue3b1zxIOmI51bnXOh5d5Pjd8MYqNOsEF+Vq2xD1Sk79T/iiQZg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "7.0.20";
        hash = "sha512-wIQ8KfpMjg7QOZapQ8FvJeqgzI8iyyvvdlBoibsQeuYJP9p7jc9O2BmDBolbn9fgdtKfyCIiwY2vf60Iz5SHtQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "7.0.20";
        hash = "sha512-PnxpVZP/vcYJrJFxyAafetPeEcG+jzyT7LnKkWPPDLK7geSktcfefPYsZ96AIMhs8MUeOXYUrQd3luOZUo2tJw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "7.0.20";
        hash = "sha512-zskULQ4seV5+Aqj/hG1VQ5RKqGcjZi7T1ceCUHbfAJOxcVQOOcSzxGxy7+Ys2wQnhQsIjWYNIji58c5tnv/6vA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "7.0.20";
        hash = "sha512-+fCP5RM7V7wOodSFtnIzEsrnJUAwnVsySDZ3rR8QTn71r9L8e04rlDicaFiphr5j537pMbGvLttPBt8NbIdCgw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.20";
        hash = "sha512-aMnnB6pgXohUYPJAkZ2tZeDVrawKTjMINz618Hcj+4m7WBYvwc31/LYIhKZ0Zb3Z/6VJkmtBvKalfbkgyDGcjA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "7.0.20";
        hash = "sha512-YYVXKrKtuFfQSnxBvrNgvWpe2FGcazsEt8P2EsyjJC7JN9DfhJtXsFz8UXCtxMlKDBYylB6UN2ROoskPQ6M+Xg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.20";
        hash = "sha512-W6XgW92qL2uwiD+JhS7BnepRaFzm4HfbzjPKGZMjtNsBzzkVKmZe0eKsTsIdS2D+eBGy9bmM610rFxyzFSLDRw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.20";
        hash = "sha512-8JJEwVHZRNmd+kiXA3lazbouUa4Y7TavnB3yjY3xHwYl+XKpCqD5OrLc5lKz49viVatasmUVfAfruCbmBxepOw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "7.0.20";
        hash = "sha512-SWxn7D93qwCx9OGmKmXZu0YZ8h2hLgLyHme6dpwje1u2N3M0qffP6kHgGzR7o1ynFh/GEbkuCe0CTqbNDcHWKQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "7.0.20";
        hash = "sha512-MJkvhC9b1UXuA2C546UKTJ+wIV5z7QQk+lsXLe8R6g9BjVvN/NUItu9H3hylGkL5Yf/oBLmlPYVUjYuy3x5/1Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "7.0.20";
        hash = "sha512-aQuov94b4ppO3l5CVG0z+VDCFVNHeklnwLS7XT/AbvSyBJ6+9BFqoSWg2uZz0MGjRl0tSA9eK9A6bkoVkPi1bQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "7.0.20";
        hash = "sha512-+wNTFv4sHMdAc6G9qlx0GaRNbBhwW/DmN4OMQVkEDgTVCiCWg+DiFON2mffojexy7trJUl6Y3MoxYMJV9/1TUw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.20";
        hash = "sha512-h3/RxhzpnpcVMNTHQ3hsprK/SrMMirLmyY2ynnUKJ6qAXEP8EUiHl8nlZ1bNGvansSbCltdRPO7pogiNJAEFZw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "7.0.20";
        hash = "sha512-moo/V26Rwf4Hq3/NH6NpWy8Y5BPHVhv7V9KILHZphxM11RpKMMAsKxGkiuNWlva6l38+W8SCIP1oBePe6FBOvA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.20";
        hash = "sha512-QxXZyylVqNbTBD5uUkrxJyHPz+qylX7xXnYuiE21UqCEVG0lI78O0X/dHYY8+35sRdU13rr0vmTszB2T1soSYg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.20";
        hash = "sha512-RICnRJ9rjyZ6ng3mQCTzKL898luIl24sUw+tm7Up27j5vieglx1gey6a1PLUBfcIVrQie9uM7tYD4oKxwn6HDw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "7.0.20";
        hash = "sha512-QYu8SGNtLOlj3PKOgSOml4qLadJnfv0hG1jH2m+Si1TewLmQKjpvI0ZljoqTAOoe8U7vpSumiyqB+bPFiRvhmQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "7.0.20";
        hash = "sha512-tt3EyI0qpyqwaFqtbG9+4BP7sukzjjheZ9/Cb/uO+CXxcep/LrKJW/Wc/wBKmkkIY/NnhJQ+Kwdjs6xcHVVO+w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "7.0.20";
        hash = "sha512-15hmpDKa0ap3bWF4rvM01Dy+Zn09h2h2MgeOj609P5iNZlsh7Eu8J7mQDdband/jPFZXWCV9CM4GYGPFEtKTIg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "7.0.20";
        hash = "sha512-qpAjc0CKz+vt3d0eoeZsjmcnb6S6IQmGnXXjv/sfqYqkYErDlBFq448CYOcLUYWdEotInD2Qc6V7wnhs9hVgoQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.20";
        hash = "sha512-na9EJ1Gk0qpCwiDQaIWFuA3n3fhav5phIoCfN9u9WKg2TQCPGigJ5qfopqb1iHeo8q/G0CT7QtV/DdoILZFqaw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "7.0.20";
        hash = "sha512-MuLMyS3eKS2ajo5L971Lfd2vwq7X/oFd8gAZFvPCyHGBkvCwsgJacNhujz+vIdgq3nSVqTullR03BSRPGZNddg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.20";
        hash = "sha512-Di92c6M5r+E9UYkOhKsdPYV+w/QjmTrdS4CIooRlsSjfm3h75AsS5+0nApBnct/GJYQ4t9ZVVnbP+njoyhTXeA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.20";
        hash = "sha512-Qds42bScEWkFo+bHjyFG1PcsU8/n0phSa4LMAQBMT2CTs1/kW2o5uvPdQvnwIJ2m2qNY6vL7J/W/oePh6hGmFw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "7.0.20";
        hash = "sha512-H9YZkbflMTqW04B9XpumTZwyNaFgtNnBxCTzM93XYNFPZbE6nbhuCUz7c2bdF9M3cZJzbm/4ITWFqBLoTMrqbg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "7.0.20";
        hash = "sha512-j7IIiyW2m2BNTt0MgcmhX3f4rl3F98mnStnY+13nlMzr+YC7ewI9khfIXv+bzUA3R2lyz7KghSZx9SaQGPuRbQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "7.0.20";
        hash = "sha512-eiJuU57LsGAsxxkbDS4iDsSWKIJH08FcJtEIiSfPtUVN4aExj1IoLp+MWFa60QA4+hkNpqs49R+g92ye8oGoxQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.20";
        hash = "sha512-d54yoCNVF93swJiCHU2Kc8yD1TLZKPBcnQAgfF1+BOXkUw3nr7uKC+pwqiaWtXXwBXBiVev0lL/qmjCxBG2p/Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "7.0.20";
        hash = "sha512-BUi8cUz+UpLC8fZmN4qhXHHvn7FaA6iTWXHtnXodSmN3ZsNtYHbB19F5ra+LfoJZ61zThEy3Nsf6/9qY4E3qew==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.20";
        hash = "sha512-yiA3VeELW4zI+7yetMzUWkTiW+pb1nLjJY3hEZXDpVBxSgHcxdkvS4pWnBK97tS9Hujt6tfQOqDbWIj1XfBEfw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.20";
        hash = "sha512-Q0NF8q0UKGD3V+95GvErCff7jyJPuyk8/EO3T72PNCfPr2AIGPZtqCuDYTt4xnLyXoYUxyKEqALn2mmVvO+t0w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "7.0.20";
        hash = "sha512-BLtlpQCuwfaoMmOYG1VUb16L1DX+ZrKFpJ5eQ0MW36MqrzR8Id9nkyZ161xneeyhxBUfi/m5zXfP20AFQQ1uXg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "7.0.20";
        hash = "sha512-s9lK1tQca5Qb4aZjEBPSGHZhDSksvfp/aj3xv8q39UqBKGtWdIAdrtcgq8qgM5nWavaCiWWW+CAEgmzFRIRpOw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "7.0.20";
        hash = "sha512-/TLX02L88IqbQDFZlGVPb/KKkGf43Q7wMGTscU1LNtNSd3YNSlj+K9E8bWY+bzFSaf05qJ7Oru0npYB+5opnGg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "7.0.20";
        hash = "sha512-RHIstT/YHVs1wHxZIPl16RicfJChzChOOqIdGP+UDC3Uc55E4IQ+aEJgrHTXi3xOw4RLp5zman0G0MmXCl5q3A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.20";
        hash = "sha512-x5KTZwR2UaFx+IvULmbSwEuiXfvpCZUYlm5KtRltd+M3yeFCJDqK+sLPUDnB2kywKDCJYwOdasfzjAhRa1yAeg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "7.0.20";
        hash = "sha512-CiWFBDlRFKu8sXeXrij7oLRTd2KcGkADb5MVGG+7xt5TIgiXZSfDEummipoK3v15cK3Z6eecVSulFZgEySVbwQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.20";
        hash = "sha512-1ly66dLhrDCgk8BiO/rxDRwUT+DbOXH3kIwnO+TiMJfID+dyqfpw3ZIbeHbIxW1A5Ukexh3mcv6ndMTkbnZgog==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.20";
        hash = "sha512-DrzZfs6NkL7Kqnnq3HTcl8oGnvfu6oYPKVoAgA4eXdrEIWuiDIalaD/c7lSfg13ei53tzACUTlKSy1dHGErXiA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "7.0.20";
        hash = "sha512-GLCsBKRie1giQ6YrjELcvSmdEG1eeKFKn5YweCEm0e67DSZuqtJX2RxIojRV+TUvWObRPhZMM708CZ258qMr9g==";
      })
    ];
  };

in
rec {
  release_7_0 = "7.0.20";

  aspnetcore_7_0 = buildAspNetCore {
    version = "7.0.20";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/7.0.20/aspnetcore-runtime-7.0.20-linux-arm.tar.gz";
        hash = "sha512-6Cuw8dUtkf6mvtQZoYVhKC7Q6d425WTmQeKWyRf39l/HVVzMBG/tZ1rWe058UKcPD0joVZ/08qm7rSvGLc9qsw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/7.0.20/aspnetcore-runtime-7.0.20-linux-arm64.tar.gz";
        hash = "sha512-37HBvvTYJt79PZlVmaXAPhvxpkxl2YtnXWwF27c4DZgjOVPmjVP8Xr7GCtTvdUFwc/sfsyVqAXa7lk8OARYfbA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/7.0.20/aspnetcore-runtime-7.0.20-linux-x64.tar.gz";
        hash = "sha512-Yu2XQ5cgQ6cuSNWqL3/fNIPPaEoysFExUATRx3jpcSv2bl56l6WlOZP6jpLa9brK8s2z6uRLuaniVTK5qA9PcA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/7.0.20/aspnetcore-runtime-7.0.20-linux-musl-arm.tar.gz";
        hash = "sha512-yoTg7/BS1Ft/qa/Ypo8dViZBVbUHiBEF0gaWmSIFe/MyiVo8OioXAmSORnEvAiV02Trhh8j9JhD4OSkJVoq/Vg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/7.0.20/aspnetcore-runtime-7.0.20-linux-musl-arm64.tar.gz";
        hash = "sha512-ZUBuFxSjEX2qNCs/0NvNXDIUMVYR6su9hYCCf2mgepSAUwMgukBpKj1tv/gy2SmhQgB58dswyj/Wem/QNRSdBA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/7.0.20/aspnetcore-runtime-7.0.20-linux-musl-x64.tar.gz";
        hash = "sha512-qA8xGTr3DVVujQJtOdeYY8g4mwZf4HeOe0Ng99H202UDulJzbEDnSnFsPDBQCxhYFu1g15sGrilXVLZzdKH6RQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/7.0.20/aspnetcore-runtime-7.0.20-osx-arm64.tar.gz";
        hash = "sha512-feFh6kX673aT14ykS1hatz/BgyMtP40in949BdaWgY2NZAKseshs4jmgps2uj8Lq+7RF6ZRD0MekqrN4HfNb5g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/7.0.20/aspnetcore-runtime-7.0.20-osx-x64.tar.gz";
        hash = "sha512-AGd4GUUNFNmtwrZfJbmgabwrQ/cuTbZR53/g5IMgvo63xVUncoHelo510PsZvvlg1NyycWG4xXvOB27hi7XKmA==";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    version = "7.0.20";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/7.0.20/dotnet-runtime-7.0.20-linux-arm.tar.gz";
        hash = "sha512-okqnr+R45ir052xA5j5eXoMkqwHZrZz/MYMkXN63CGH/wRjJq9qfLy/tQjc1yieqwVvsjMX8NS8FvVtyYmWEmg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/7.0.20/dotnet-runtime-7.0.20-linux-arm64.tar.gz";
        hash = "sha512-wkUSXuJwglIRmhVEVW4aqeAKoYsjA95ph32hDGwX4/JQJLdJypO1O+du4Ojkp11AP3AZuLwuUO0SePZWyy9+Bg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/7.0.20/dotnet-runtime-7.0.20-linux-x64.tar.gz";
        hash = "sha512-h4VSlzOFVae1d9fjFOXb8sI1D4yGekic0eU1Y0utXBI6GHFGTTf8lCGDf/XUJsLq3svg9gu/P9MrwkYfR3kKQA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/7.0.20/dotnet-runtime-7.0.20-linux-musl-arm.tar.gz";
        hash = "sha512-JczDc9HEwOt0HgSMb9SDZjELNqxvBoxQ9rwBNCoABGQUToRX5+G2zPbZlUTUkUAi78uCTnVjZRe79hyUhSzddA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/7.0.20/dotnet-runtime-7.0.20-linux-musl-arm64.tar.gz";
        hash = "sha512-VSynNGf4BD01HCDXHflbqWOzLox1cG329dP85SXz798TFN8pbET77a1VdXguN2M5mKebLCP390IPgU7iSI8wog==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/7.0.20/dotnet-runtime-7.0.20-linux-musl-x64.tar.gz";
        hash = "sha512-MbnaCNYzzQAo6wjDbuLFw8sb5tPF4BDIWuKRSW/l6Bi1vln11Hr/hu2TnCYPdi5X/waTSk0JVDdpNbGtx5nxvw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/7.0.20/dotnet-runtime-7.0.20-osx-arm64.tar.gz";
        hash = "sha512-rxy2LinGlkjr4zTmUcJwPNXof6C7KMZwuss7PdFgiurjWuU0AsXrTti/NKvYMaCMy174Tl7HBhfZ+NmWn+e4+g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/7.0.20/dotnet-runtime-7.0.20-osx-x64.tar.gz";
        hash = "sha512-rNzekvLy5DWE7lm+RH93j0oVLDCJdce9xcI3K1u9MJLrnSIzrsO4J1a6HjUqCHf/wX5MjPsgqd6Rym21TXm1kQ==";
      };
    };
  };

  sdk_7_0_4xx = buildNetSdk {
    version = "7.0.410";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.410/dotnet-sdk-7.0.410-linux-arm.tar.gz";
        hash = "sha512-lbY5oUddm3Y31BoUwMqzmTs6K0vmPb8lH/74QEYcUdnV7NeO8JyFf+KDmRVfekBEngjHozzgiFDE4Y76q6tFrA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.410/dotnet-sdk-7.0.410-linux-arm64.tar.gz";
        hash = "sha512-LbajuaUy0vWaK0WeY0IGkTqVhcgh8/V4pCHjuuNGqS3ZuFt26940PKMFcnX37E0LynHLt/K6223NtRYkToTaRg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.410/dotnet-sdk-7.0.410-linux-x64.tar.gz";
        hash = "sha512-ILjgKXkyjkxKFEk/d5HtQZqr0BdSM9uAzWDiwAS4KbPoMBKB6oaye6gYNyRzrM9abVU+U1TFSRfI6E0l9YVcqg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.410/dotnet-sdk-7.0.410-linux-musl-arm.tar.gz";
        hash = "sha512-x7Gc3yExJkVv5/IBcf+/XMQXcjBbR9jQbGRhKlCeiRMSZAXKjqW2T5P/TSz+op+hKGcdQO8jrWadi0coIjjfwQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.410/dotnet-sdk-7.0.410-linux-musl-arm64.tar.gz";
        hash = "sha512-O+6089U2DMm8Fzm2kCj1grZqajhMlmj/EqD9ucKfktx1e3sXs9/MgeVQP5razNe56lSQ+OFinN2Y4bRZKbaS3Q==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.410/dotnet-sdk-7.0.410-linux-musl-x64.tar.gz";
        hash = "sha512-Y0W6gTmvQteoMwtaXhfHGz4GgGZWEAbGi/4r+1wavSiS8NkD+3rrwqU22Ee8End4DNZR+lMTMMFvowKgdstUFQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.410/dotnet-sdk-7.0.410-osx-arm64.tar.gz";
        hash = "sha512-wO8ZFPKymFBEM7ypzasC3PMkQh7OOWV7ZlI/E7enFm5yZ4NnOmAvtGLz21xT9ZqJOBuRjnZY1JpXdjtDz3XO3A==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.410/dotnet-sdk-7.0.410-osx-x64.tar.gz";
        hash = "sha512-eC4VwZziCqgzNWbyPC08246Jx2Jt5jMN32cMRCbjDMhU5E/zNBV4Yirs8hD6Zt3LY6fSrWKe2Sy1WCq2cPlT0g==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_7_0;
    aspnetcore = aspnetcore_7_0;
  };

  sdk_7_0_3xx = buildNetSdk {
    version = "7.0.317";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.317/dotnet-sdk-7.0.317-linux-arm.tar.gz";
        hash = "sha512-S1DHTRWHGrRc9/0Bb6BR8Dg/AJX5G07ycQUCgY4vn2kCO00A1YTvd9gYeujpWo0pI7PQPr4qP/cKkQntEvdI/w==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.317/dotnet-sdk-7.0.317-linux-arm64.tar.gz";
        hash = "sha512-Irrc2yy6Dxvtsfy9yZJppmoBojIZPgC0KCOAbO5dRhlLjdAIpT4XRVBypBD3e9NRZ281FnC+lsE1ctjjDPrRgA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.317/dotnet-sdk-7.0.317-linux-x64.tar.gz";
        hash = "sha512-kG7L+jGxCuXiqLpxPRE8zYPjqbnk0+MiSCaSiRVClZ52xR213Tgl+0os8elRc3AGqZvnKQ8wnWgiVn06Uzp6ng==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.317/dotnet-sdk-7.0.317-linux-musl-arm.tar.gz";
        hash = "sha512-fKoRN8pHJHGrlZ3s634+KCigjbX7Dhxrlz8kcKHLbIv60zLMrDH2bhGYLkc6/4KAmzX6XANkF4J66DcTe+NPOQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.317/dotnet-sdk-7.0.317-linux-musl-arm64.tar.gz";
        hash = "sha512-7US11MyzefQoaSLiJtGC5eubwS9M7bYALwbleUt5XT6/GajlqOmQxFfff566mUe8HHIQr2qN/yxnItZMnmHwQA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.317/dotnet-sdk-7.0.317-linux-musl-x64.tar.gz";
        hash = "sha512-Wn1fIXAQs1QfqdC9tD12lJaFW54RQ4TPZ4jtR3G4NUZqsYeMU3nIkUk7VLh8FHB3j1CTHFpsiZr2E0gZO7lj1A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.317/dotnet-sdk-7.0.317-osx-arm64.tar.gz";
        hash = "sha512-tfNn4eINco1xZ8geQUY1jnYPE2ue4PxBDYE8FDZuOLCaBpAxqoym2N9DhDW2q04umJvjCeCXFpRZNl1L76+fWg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.317/dotnet-sdk-7.0.317-osx-x64.tar.gz";
        hash = "sha512-09vQ/ny8YjiPFQrbpdgYq+45hoY9dXzmMIj0/qv4AQUsCKYIrNUDb5cZFDX+mSJKyxLHNlvn933vKFU6IxrDyQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_7_0;
    aspnetcore = aspnetcore_7_0;
  };

  sdk_7_0_1xx = buildNetSdk {
    version = "7.0.120";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.120/dotnet-sdk-7.0.120-linux-arm.tar.gz";
        hash = "sha512-epZI3jwx+NElfZiYL0rivTusMkQLz8uAQCdShZkJNK7ocZASoso/VkZUblZtKWP2O/idGbVordxNMkzpdOpLxw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.120/dotnet-sdk-7.0.120-linux-arm64.tar.gz";
        hash = "sha512-9TD3lK/jw7m9h7jtUJoaE7HI/m8rxubM4+jNa1YyfA/yf8E4EiwtrWh3DMUBVzfgB+9XBlmcGJ7wzHUhy/C2VA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.120/dotnet-sdk-7.0.120-linux-x64.tar.gz";
        hash = "sha512-y5+rqDqydsk17zWzHwFspGF/DZZ8W0vx6ZPCFZmS+1nR3SXc4JkokVuf9Ybq16z5LsHdlpN8kzF6mcoMkrYWyQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.120/dotnet-sdk-7.0.120-linux-musl-arm.tar.gz";
        hash = "sha512-HNomb4ipUPRUT9/M8ezCaBa3XCn0hmv9mFiSkJQtmCp0zhfy9QfGKAsPM3t0OprQHlOjwQAcdHe91K3VO7BhXw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.120/dotnet-sdk-7.0.120-linux-musl-arm64.tar.gz";
        hash = "sha512-XTEkw9rx7RzvDIOOdTY3rx5SAws2Ywu/p9uhdqfsok/p5cTfnv8hcPqWz2PgBV30LwlQs7WQDesoJZDkthLz+w==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.120/dotnet-sdk-7.0.120-linux-musl-x64.tar.gz";
        hash = "sha512-xQirUxDXQ/V+p4YR/+NUJo/og+fGc+6Ajaqm3eMLpFTV1w+BkcSetSrkqAwGLtZJC6HWt1L8xUGw63g19O7ofw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.120/dotnet-sdk-7.0.120-osx-arm64.tar.gz";
        hash = "sha512-3AaAHY3jTfaY+T46qHLVcTHdPjOsT3zdvJYiORHg/zL9zqeDMtp74AEzYskM0k2y2GweJ1KXvm3RYpSPK9OMvA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.120/dotnet-sdk-7.0.120-osx-x64.tar.gz";
        hash = "sha512-lN65mIUJ/L//w1cRTQ9WRfxrb2FWZkBAzVZDoZG+8Qri+6QWiqaJ/32hobb6d5605Tp3p4R77Ot/C6RR0sINVw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_7_0;
    aspnetcore = aspnetcore_7_0;
  };

  sdk_7_0 = sdk_7_0_4xx;
}
