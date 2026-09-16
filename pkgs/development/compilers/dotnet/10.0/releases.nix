{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.11";
      hash = "sha512-8hr3cG51FlHTl9uKmU5Z2Hdt7q8HbfJ8MPb94/Kcp+aou0YrLlGXBUQUUiAnv98VeRA4CqnQCEccuWDuGH0gGg==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "10.0.11";
      hash = "sha512-KjZjt8NeY1u5vYW7tXBsaO/atNrPeAyrHJjhqFfmLB1wnqwf/KpSFXUQuI20DuDdyH+1RT9Olj5JAhvQheZIHg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.11";
      hash = "sha512-3XAS30UuQNs4UAmbE6k7IbPtmXCT4euhms+1JF0faSPhgfBPlt/GWm9hhc/4bt4f2ubLGNeCzbtVTHbVB9OXYg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.11";
      hash = "sha512-tHHeb+axV3SHYPyafZEbcEFuJlvRlO395guslArUZCWr4JX0x2vd0ZE895Vc6+HQnQRQRPZJKYqp4jWrnxMLhA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.11";
      hash = "sha512-R21pKwl2STwYU17wo8b8pbY+xKw0LYaNMi0wn09XoVs6lSK2vnjuV2CTf1zJ0a8Ew+iwe7T0tTmi5N3lW7DE1A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.11";
      hash = "sha512-hMVB326ViZa64sqR9bxmf4oB41LMuaTrGRfihXZw3dylFRFfZPutLwJrKZmdisSvBcNM6kfuY7vtj9vdR9IbuA==";
    })
  ];

  hostPackages = {
    linux-riscv64 = [ ];
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.11";
        hash = "sha512-AwkoJID6+uU7PQH3ZeM/+jV9ezCINjrefHX+Y87XXZJxR7tY0v+B6P7f+MqKNGR+4lvVnBRx0vZYJatPQ6WKMA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.11";
        hash = "sha512-ktHa71j6xxZzaSYVn2HKips+N5FI1BANjhvRqeGf4oW32orhMhI6kSNtt9M8qy8XStB8LyNiO7kZnoOXS2FhBw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.11";
        hash = "sha512-EtTwxmg9PfefrrT73nNntoxnbHN7h4X6LlIm/ZJq0T/9J4uf9MnlDzAru+HwNof+f6hOvI/kwwXxM+WDPJ41iw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.11";
        hash = "sha512-kb4KNaI16vCAPnlAttZkf8oIBRHoUgj2wUBhc9BciDI6Ue/WNv/EGIISiUIpelKgF/flafOvexv/Gpt61Io/+Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.11";
        hash = "sha512-xzT3xSscegBsQMjf6IOLE5Bf6b22NjeEkCvXba6D/1Xx+ieIysxzZliW2Q9CdQflgU7HvzvioYNLoATowC+/nw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.11";
        hash = "sha512-vwqFcrcZUxWoDJyBmogmEeGOmKR7zXCV+NVfnaN++zAqOIPidKddYzNzqJ9FNcRiu/rCXeqas7cqNwXLGEzwuQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.11";
        hash = "sha512-3kvlzQlNnqrmtB0vdTI2T68sYPvFB7aGfh5holsmDUig2gQX02B87Wr274bm9xyL18xFL/1JCIUbLbFcPJn1vA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.11";
        hash = "sha512-ppF4C2qGGtZ0o0ykjwTHJutXkcYZZwQ8sZtAw5VvPodkGfKnRjRieOeyNvjXUR2fILKvXZPIDJ2YseQ2xyV1LA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.11";
        hash = "sha512-WC6jIn/7kzRK3bRut3rMPeLmJtWroHfFc+v5PJ1QHuBkzNJ0VKUclB7Qry41Pmwj2373k8UPxM/KkZr5CvJ63w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.11";
        hash = "sha512-kV5tBLWjVwOME/YFUNualRinSS1ZqQKCM4W6Qlrn86B3q4vros9EZHofz6cSfSrXDfkpUPuBVi9rifDmBVfS2A==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.11";
        hash = "sha512-Y/8LzYfB4LT6GPvqmfsKx3+LkTzHoaRP7rn3dC5kRc84Xsiio8oyEegPPP5P8XzZDeA3lG8YzA6cNMZQgjRRlQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.11";
        hash = "sha512-zqZTeuF7gT7ZwAgO6JMuJfaFDzqsrxU8UvYP2q9ZxRWHDOAtsxMtp/8Yc+WUPl3FJGi6jw6KJx8AWYeLQ4JXJw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.11";
        hash = "sha512-mNepSLSVvthaN56/UO0kqqbjo3svV0yTQu2BHaKYYTwkePP208VyACgyElVqTVXNA5uKFN1rfw5AWcOG+Z5+FA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.11";
        hash = "sha512-BAQNYmn4y/pUeNQSya5QllcN8VHebtDuMh4a4m7Onq5j/x1Mr1N+1NW3qX0RwbW6ePrjtW7WR+RFKTgX5KaDJw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.11";
        hash = "sha512-DPo/BrV6xiG+mRkpBij1eolExVw9UDSzCdJj2qB7h3gqTp3cUGjgsbM895P4vki9vd3FMktWL/VjE5meswYXiw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.11";
        hash = "sha512-0duFxTzgRZBxd/SVNa5aM6YIjrDrtX4GLVv40ABLA5B5L9IHADupqOjj5w2fW6lnmaOnDSyxqZ3lz4PcQvsx8w==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.11";
        hash = "sha512-D8ocOD9o8tbkxJwkaMGDpT1PTuX7jhksZPzei5Ehz55jFB0/FAK0nOFVQ1DMglt3OqCVBpXVNmnhjHj549Jy0w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.11";
        hash = "sha512-W0AXF+Q0kdsFHlmfvWNS9MtmQTB7Ev+mjKuAGjyjNV3/PLw3akeuvs6E3UTI7pyFYTpwJdfWYZ1IvhUG1pmeyQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.11";
        hash = "sha512-aCcyyQfyqQbNgOkvTIdW6yBU3NDXxz5g/ICaYnbVdBq6oGknzWqLLX49V9hK6iiKRe7JTZXE6VB821y95sv5nw==";
      })
    ];
  };

  targetPackages = {
    linux-riscv64 = [ ];
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.11";
        hash = "sha512-HXNAvtqmojFdqcOyGam9C8sCQ6K4AUjxck9rvHIOND57FdonwV7/k6FBJdepdY+D3cuMyowQyCnUWjfxsUYzjw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.11";
        hash = "sha512-wwYZr0at8NAckGs+lpPCdJu8nxDr0Lre6JEoAwEmz9u6x2TL4/tBwhbllQJhNupfd7JBzC8TYuo/2pA1SFxN5g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.11";
        hash = "sha512-Bzs2UOZuFDsRvKkYHvNiY7JyeWz8PH99vjquEs6XeS6FQi/5IfG4zlnIJSmd8Y2WQ7lot1UHJffYrPrKtCs4kg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.11";
        hash = "sha512-WF0DorC+Im4Nb7AywataUJumuziKOHgo95zoL00WxKmYNGaybI8aWO15gwKlLH5Yi1eKfdcWlR39UGwem2LEwA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.11";
        hash = "sha512-P3TSxJrui5ePak/KuoscV0Acnd1qKpfjE7ewkhsf2tEZbb/erjwAVNQsAz+RpueZuEDoffe7evA6C/WViM8PmQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.11";
        hash = "sha512-gDHFTYuhJV+0Kg+lmwS6CZWqoAc3daRCktKmvZ4PqjLD9h9ZNNYKZBhP6Y6hnaq1V4T4qN7M93dVwZtUdRpPeA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.11";
        hash = "sha512-Xqdt7VrZhtfQLVITNHxH8ZfvlJLaqJ1DndaLa9zkflMriyhR9KDpnInNhFCeASfqc8/5WUu4gyhcAtcjtkgxXQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.11";
        hash = "sha512-2lKSs6dpNXSgX9Wuj2iasd52IPUL/VgP7YLb4CB9OnytsjFfVkQEPIAfIe9Dy2ke3Lsm/OotZVNjJAJcnak5CA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.11";
        hash = "sha512-cvj23w05/znLrDKg0rQm+YSjg4FP9A1yCdk60VBJamogHgDuAoJCBKwjcwMhMap1hHg29PRbRRg9dl5yLCAaMQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.11";
        hash = "sha512-T6z16bUu2om8Qes02PTkqmuGgUlb10EdL77cFOAzno8PI02nl6Oa+cEmTXgXkHLv9Tw9ALRGytgz0aaQeerVWQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.11";
        hash = "sha512-jBVAhk1hdU+IkKJ1qkUODvsj9Q+VZlrsIYwECWgL5ItiGprBVzoQPxJg8Ei9ZZ9fTn1QmcYRMu9g0V/HXmkUbQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.11";
        hash = "sha512-I4mBWVGHJXFsduPaH+vGOz6/SVohsdOGi5hKabNMj5uJqiId7dWwoymtT251BrG/xVt7TckJx59D96CRvmwjRQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.11";
        hash = "sha512-ef6XpQH4KI7lukxMuXnh0iDM7a60cR0tFiynPPmRK7TnOHZXKpwIlPd341kInZJvMw+u2B3qaHb3rVEMIxLWlQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.11";
        hash = "sha512-pn8s9bxtexdA9uhy95CMkGe7mFpU6Y1kZsNaGgrflcIvGrt16PVY7jlVZt8MBtN72irHEyuyRQHh/b88uJT8uw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.11";
        hash = "sha512-ueo1w4YIFUv6T+GAp4vLPxR315sfZypwTYhRt5Wi0LWgGu5n+yFMpgylSYFXPWA7y5wE3gVMmlZzxjG3SCJkow==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.11";
        hash = "sha512-3DwHAwHdtyoqHKYqhGAgRoJvzuuimFQJ8TxxUcfFOsftEbwoG+bSEV3duClI64M5mnTafeROCjQoQitCGk3vJg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.11";
        hash = "sha512-1PtAGAKGlL7mR3fNQJGzNRxBXJ348iGqldF5zl091xkNg3mmTzdj6bG/CN/zHopjC52KZkIMckxR1FdK15n5UQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.11";
        hash = "sha512-+syDoW7A7HtNQS0h+KcEYkuDUTgT+7HotjO6C+4z1O/8/dfaYf9XJRhKXPuQtsZ2ComHNvVDF7QLW+tqb0rU/Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.11";
        hash = "sha512-UVi8qCBH6tpG1a0Qd29kpAV7llAyxcbyfPuDaOPzs1ULcisgTjxdJELzxYCuUdY/bDp6khMcJT6jA9HnsQcJmQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.11";
        hash = "sha512-LOiZVBP4eRyW5gcGw1jIGxaIwTlcz+d6crpXMptj64LcMjyVO0A2Axb8K1nD7OLmT86BFJtPGBKSiVrZFUsM2Q==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.11";
        hash = "sha512-W+R3ufaxoO7AeObAyg3hGKzZV/YtReTiZPkdjfA7WVNjiQjk/fbwJj3TjvSbw+mmoo/9aZ47bCIn8HHIYKjzRQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.11";
        hash = "sha512-NRGKSBmEHyBivFPMxYofSTaEmMS+T22wc7w5JaFXyAprI6o5Lo/wPqwNk3o2I3NI5WM4jr1WBclpXhuM1BftDw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.11";
        hash = "sha512-FOQlm3xWHxIv2oqGvr32oJKLK5Iy1gl8XNTEv3zj9Ya/ZEoRjQOu5KvcCnqRx6HRHtrRUumcODdbBg7wEQjMyA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.11";
        hash = "sha512-mJ8Q2e3gOULaV0mSRIAEXZPeuBmck9uiZMqHX7K74YXNsBkmjI4VFgWqW6/gpAkkB6UpHljMhJ9rPe2hPr2bsg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.11";
        hash = "sha512-GFB2xoTqJzf9303GjJauGQaxiz0Pd5g2QnvaVvyTewB2PUCMqu8hxkSwgvGFTsgN+FvHKBKqNixGIFkpliqePA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.11";
        hash = "sha512-sZ4JNPUmJ6WgEsSP5CSlxEwHp8An1PYmdNHPe2+nKlGqLamjKlITHFm8t3k7I06fwcyMPzxZIWam0FMmapFmMw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.11";
        hash = "sha512-uAhTHRU1I3ubBbAm4TnApBWSkTyGOYYVsbtOxMSDbnh3ddk0xX7Swx9uKaDWCmVm2LlALziIzTNnZnUiXEPHYQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.11";
        hash = "sha512-VEzLMLjUIUBn+8QpqNzlySJyJn2Xkniwwgp+ooCt9PzAZlKjlPev3VF+FGQt7u+3kksBOkXUo3diua5CYlf1MQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.11";
        hash = "sha512-ytfm69gX5+Fz7ddzNw+eifFnbVyeu7r4Qkd8LiOgVFMsuhKVLP98oHpIEipcYu2v/wJDBx0bDNDGBeU6i4rANQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.11";
        hash = "sha512-UK/qnh5GYVUpg3uzrqOHDUUnYGZqQ/eOW2sVUP2lQqIP5alqdbgfyCwX/LLejEcuDarQcG0aod0QQ9VtpfP9bQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.11";
        hash = "sha512-JnlrGXHx2XqDHf8SX5rclpBOhB9fyOvcjgRmYV1P4g+bqmBP2ELulaXC6VZ4eZA3Yk/281EUNTtm5JRafvfmrA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.11";
        hash = "sha512-0hCNr4A8jHFPSAL0WKHTA4ZdRuEfrJPzdUUhSrX44NzlV86PeHsyq8ez+O+UvAwhypvsVwaxJyKrupVsFMC17Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.11";
        hash = "sha512-7+/J1t8Daj/Rtrf7ySI0ONwPH/pGXmIClDQKVXnv6L6WBfYBC38azortAsqPRlvJw+UKodGl8nwydxNlxedxCA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.11";
        hash = "sha512-7t04BA1C4edyq3vALuSIyJPBKJFx4jnBdvT5MZjkF50bLuNlM9QV+fF5W1q1QOtuvh0ldh6IXg4SgSNwV8Dwiw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.11";
        hash = "sha512-NIe+WI0m5L4HrZ9b+wOhCUkrT3WZyIC8MQuHGzkvJyfUyR8ImMXYJIu3TiJsdLHUkgkqPK92AGQt7CQIc6vydQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.11";
        hash = "sha512-+cDuH1GmIRK3/3rvrQnF9keE6Ry0RVCXu3xN91riR/hseQqhZ5UcelODFgSvUxspKqKaF7oZQ5kJS2dQw+0rbw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.11";
        hash = "sha512-Q3mAJ0KS2Rva8Stx3A5yctLezR6jh/25li9MbQoEtmYgxX/eNufg/0xOjZAmre/gs15Egk2W2W6nAPpHBKfP1Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.11";
        hash = "sha512-WvFD+6nJ8zBDoEqGru/z2Id8ifSm7/Zr/+wkOFWzxQMpRBByYyPxyjaiVLXMB3nYdy0KqeLQnYmF/IcJAuN/WQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.11";
        hash = "sha512-2Zk3fov2xeUQha41s4gz4DuEc0YB69Q+zL1oCXKJI5d+A4p28wfEpZMM2pObP2cR6jQHyXvlvybPom/2h4oOIA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.11";
        hash = "sha512-G9oLYs769tFAOQ2/LeMn/ZivgmDaJFCSYcBRrjV7NTrqqlMn/WtvyOrn+xI255Tvc1Me7F3Y/JZYMYaanIYJpA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.11";
        hash = "sha512-yUOY97MzX8Qkf+wIXPsyY39yZB8sn6Sx6/mQD5mPUxYIcwYzgIhsHWW1kwVlvMZtDzO6zZArD+g6m5OwMRvUIg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.11";
        hash = "sha512-nJxUVSO8MhJFPrjVt9rYNjYOJdQWzhaCIcV0UUzVY+dGrZ9Cdt1UehECo2rekCEyhyzRZ1W2dN82CRuPCAFXog==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.11";
        hash = "sha512-Vm6On5JxtOrVC1uJ4ab83ynLw07+/WrlRmOFGorGpgR35ysW4cz/xngxczROKmjeJbhNEzGypjFkZ2yuc4CaIA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.11";
        hash = "sha512-lTUDm4LmzcwmJ2YK/Uz1vv9LKBqIFwpZWoyMcEo+w8fT55DXfDK4OT3bQ0zPBFFJQe8h6N77B0yJ75k5p33uAg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.11";
        hash = "sha512-Q8WvdT/HN6TfOmeiJLzvoCVPh8cytLS9hpqKsJnY7LdioIu2PCKFvxF7x7R02bUjaSlB/Fp1uOoHX8Axor2aBA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.11";
        hash = "sha512-fN6QvY/QPIjuRAO6OFyhe4TVXucaTqHMl9NHntyKmCd1aY7wk5Sa75wlhtsBZrL2HA8T1vqe6Rmz3SdJZPGfJw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.11";
        hash = "sha512-hbc9T88sqqrvpFuK6ot2Uh6S4lhmwkojch6b3Ee32dJ78etpb5X1PYteDI3Mj8+Pt+QkXgJn2htnAkIaDaHCUA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.11";
        hash = "sha512-jn6vM2lHbEEf/xxpMmvj6D71MqL8D7SdiBa+II1BUH8Np0MZav1HkaLfOGgfhAGuQRCYtetlLwsStivRDhPy9w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.11";
        hash = "sha512-T2Pz5AKHAvbZF48RbDaUkcy2cXuDgpO6Xlcg15Qq6uLmHhybjcElaeC7UsMgqpCGpnAKb2i5v0e4q0oQP39s0g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.11";
        hash = "sha512-+VBBie/7csYTpLjnvwVXf4S4jrVT3vjhFZyeZZ/4JwCA9ItB9z5IpwnBBa2GxwJVFd/7RGd/E1SYnwX4aXYOqw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.11";
        hash = "sha512-1bPT1N1om7XOVTJqb6Z7jlgUCu2GP6NQeJqlI1CPF8jSRH5mtNHnLzfQxi4UpEzjhgYlznyXFOVAr7OQFsoFYg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.11";
        hash = "sha512-5zeZm03nY0Nxx7gHwYprgWyARCMm3qyK8md2CktC+H5TeDlnq7oSSNeHUaXnLid54xuyhJlQY2EvVnVR4XL68A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.11";
        hash = "sha512-pyx2ohB6gpmGwS1nmf87AbVM2f/lDj2+5UCa/EdOnf+a+snaQxNTE4SjUG5pDFcNutzLgqWmkDaADoWBif9dpw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.11";
        hash = "sha512-WH3iv8aCuiuj8gFDliNbp85cyGO/OmxVB3rxHd+zuBMEcC9eH5OpNYfjKPJvd4yYOYs+J+i+jlqF08eRNWEECw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.11";
        hash = "sha512-oFkC0Ua6s/PyQmOHMi658wWqtgjBP/KAKDARDTtajWAkoI59U+RbiY+BpTzoX7Q3TKJheBbfny151zUnrXoRpw==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.11";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.11";
    srcs = {
      linux-riscv64 = {
        url = "https://github.com/liberodark/dotnet_riscv/releases/download/10.0.111/dotnet-sdk-10.0.111-linux-riscv64.tar.gz";
        hash = "sha512-+dA0vf63mVr1JREoVfK4c+qE8vgAdm/6jAFAyLGPiAPnbgUS8IjANEVolug/xPks3/bjpYEFx9+cRA3UWi0inA==";
      };
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.11/aspnetcore-runtime-10.0.11-linux-arm.tar.gz";
        hash = "sha512-cW3SeY9EVwevUiDQycVYfv1bJ5IF3NhcT81IZtKkOUKiZmJzTnq4zHTSfDn0eCU+o2XQeNhixw+w+Rfxhk+yYw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.11/aspnetcore-runtime-10.0.11-linux-arm64.tar.gz";
        hash = "sha512-lUn3pZ1db33T6WW/iGMWmLI5dK/0401YkDfWrpo/RDOQKIG00j9+GGAquVSCP1vjUBUFSm7MtXBBsPINkoc+1w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.11/aspnetcore-runtime-10.0.11-linux-x64.tar.gz";
        hash = "sha512-TGvgYjMwB05pnauAhL4Vobrrt6UYwN2M6Z+Tz3l3fNRvOjjvnSXtwVLtYG8IS2Nza9nkCC6zLRiPw1e/asTR1g==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.11/aspnetcore-runtime-10.0.11-linux-musl-arm.tar.gz";
        hash = "sha512-ocrsGnmmjL5YVpxA3P+SB/op2F+QyHAk7RwEI0dT0Q2IGItA31v9Rb2gQlNvAxEUyNIY7Ktl0AVhLy8J6TkqSQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.11/aspnetcore-runtime-10.0.11-linux-musl-arm64.tar.gz";
        hash = "sha512-YRgEnBOmZRJmrAWsPwcbsWn6A5vZMNwvBhNcLB/CDKwH/0uMaaZ3m5EZE63AFUquivPLYNIzGSUcu7403ZlmnQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.11/aspnetcore-runtime-10.0.11-linux-musl-x64.tar.gz";
        hash = "sha512-k/iOBHbsb/Gl5rKPZqmnwCV0x1QkqqDsdOfTAkNH/7w/Tm1nlvKvx8LFyjUndaIUhhNd2UlvX3QWO+DjPaxdkQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.11/aspnetcore-runtime-10.0.11-osx-arm64.tar.gz";
        hash = "sha512-cikD+WGArQJeYC55ZFAMh7A4X8hiv32zwXTV7iDj0HQE4Q4Zw4vVffCB6rCN+KsG9fXTSfoaHDtsR/aAUsMJ8w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.11/aspnetcore-runtime-10.0.11-osx-x64.tar.gz";
        hash = "sha512-P+1bUkNrtKR3lV4qy3QQzhAP4svrln6bYN1cTd3ewQhUri8LiVy++4Y17U3joJMz+xbo7jbLvvSbHZYydY+Gbw==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.11";
    srcs = {
      linux-riscv64 = {
        url = "https://github.com/liberodark/dotnet_riscv/releases/download/10.0.111/dotnet-sdk-10.0.111-linux-riscv64.tar.gz";
        hash = "sha512-+dA0vf63mVr1JREoVfK4c+qE8vgAdm/6jAFAyLGPiAPnbgUS8IjANEVolug/xPks3/bjpYEFx9+cRA3UWi0inA==";
      };
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.11/dotnet-runtime-10.0.11-linux-arm.tar.gz";
        hash = "sha512-fC8Ke9QjELjQnbzJDs5iI5fbw4622jokmzAibWPQEZMwQRyv/z3pUNghtc60mUBLR9tV/aqFKbBN0UxjI5ZhnQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.11/dotnet-runtime-10.0.11-linux-arm64.tar.gz";
        hash = "sha512-KnKaTv9qVeJxs659Tyvpiu8W3yLjuTFoJ1WOIE94gbvwt7n468+xoUGch/vLigD1vnK2R04CxpXDCyxSuvtl7Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.11/dotnet-runtime-10.0.11-linux-x64.tar.gz";
        hash = "sha512-ZMd6X5jW38Yzk+1dL+1HwoVcfN1DIgCLOxPh0LcQrvwfun5WYS8l9+iisbbO9c93yzqDT/NoXnI60oZwPDOW2A==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.11/dotnet-runtime-10.0.11-linux-musl-arm.tar.gz";
        hash = "sha512-lXSLgg7yMeWtLSUtTPvlZ4RIAxK01qgDk59r6IBC8Ais3cI1roM2rkro8gkqEimjPLlPo+tl31AsNLdMuDEiew==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.11/dotnet-runtime-10.0.11-linux-musl-arm64.tar.gz";
        hash = "sha512-f39Kf7CZUjHFy3jnIkyDyWkRwjNjAFSOmzcA/6Rbi5yimKxS24r4SXqNPQflr1pUrXM03DuaKkGL7qIZjJWitA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.11/dotnet-runtime-10.0.11-linux-musl-x64.tar.gz";
        hash = "sha512-1wUZvI0X9cHJNPgZl/tpPpm/z6OftNSmmZ3ExcBJBFSNhpXOwdWOGCI9eAjZiFQeyrKNwTg6yVxQZW0eAk+Jtg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.11/dotnet-runtime-10.0.11-osx-arm64.tar.gz";
        hash = "sha512-6WqKgQjVo7cOgnVnskk+3lQPNwXBIJ5/NHNrpqo5jdTQ0V8x62Z8nMo9vNMK2DsxWobV6aE/0sNw4vwM7OckNg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.11/dotnet-runtime-10.0.11-osx-x64.tar.gz";
        hash = "sha512-ysotsQD/gd0PEfLQS6HaiR2quaAV2tSqfdDPYX4qBc+y7kOU2k9FW8YnSNig908Ah7l/zqBfCGkat1Zy3Xm8Vw==";
      };
    };
  };

  sdk_10_0_4xx = buildNetSdk {
    version = "10.0.400";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.400/dotnet-sdk-10.0.400-linux-arm.tar.gz";
        hash = "sha512-bAJgyl9zXymZE+6xmFGk/F4ad0+X3lXD8dgReZ+zlSYfupEyaQwXopY/JLKzVpUrzNT/ZUrPGflqZgZ2+tDHtw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.400/dotnet-sdk-10.0.400-linux-arm64.tar.gz";
        hash = "sha512-obRdpY5Vkf/5CaYSasa/we+cErxywGJfeBXoOoK+GpAjF+6Wkmy7+BMkpFxqvy7YECohbQUHh5zBZhWa940bdw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.400/dotnet-sdk-10.0.400-linux-x64.tar.gz";
        hash = "sha512-EDOXfdg3FQ4IFM8MXVsXzrY5Jf2nuiFYtHJYpL18BIz4Lqw7wRZvMUb1MSSj9fugnbHeEmDSzpY5mGAwO0BLSA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.400/dotnet-sdk-10.0.400-linux-musl-arm.tar.gz";
        hash = "sha512-YDs6MomO8bNjdMA+z2p7YC/D0B6KlJXOgOHM8GM6yHjNJrWp547QONLU+yQikfAGA/o13lKknUgM+/FDjeNOKQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.400/dotnet-sdk-10.0.400-linux-musl-arm64.tar.gz";
        hash = "sha512-nR8NPEksiNYdbuD+H/pP3pBEXjaN4/diXJjQvpgsghWigaNM68psZVrBDjE1AeaCQBjZMzTxcxQqAY8pRGOJ4Q==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.400/dotnet-sdk-10.0.400-linux-musl-x64.tar.gz";
        hash = "sha512-r6/ZX7mOpcBb7q1ijaZGkbfJmUWezZrqZuAn1RQ2A324AqgcoX/X7vaR50SY9RkpA3VStFMO/4iRHzl6l4w3xg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.400/dotnet-sdk-10.0.400-osx-arm64.tar.gz";
        hash = "sha512-5EDppY1P93Qcg0KsPghvqe4trcJeAcBEmogxenTPvWNiW4CSw7KhMa4UsWqzQB6cxHDleOTGWnKgtXhr0jCM3g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.400/dotnet-sdk-10.0.400-osx-x64.tar.gz";
        hash = "sha512-PsHMVTmv4XNBFFwc5hpDQlRqBd51BTzMvvQWnHYRMUa7d/MIV7W7R/eEaQwIHFQ+oWByij+g0GrxGu/a/rsMfw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0_3xx = buildNetSdk {
    version = "10.0.303";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.303/dotnet-sdk-10.0.303-linux-arm.tar.gz";
        hash = "sha512-76OisP9NEi1uf/bgXgdyBm+mI9FFBUNO2R4bIqmvf57DdF+QZKXuFoZOxs9reHwdyeTCtF/RyR31CQGKFGdSTg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.303/dotnet-sdk-10.0.303-linux-arm64.tar.gz";
        hash = "sha512-Yi4FkZgFjuX5LXgXvdg4hUgKl5YoNI+HggHLjbpS0WjBoyT5lDoOegOtVH2FMyqoLxas7SnaWZ7wJCK1N4RS3g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.303/dotnet-sdk-10.0.303-linux-x64.tar.gz";
        hash = "sha512-U43xHOudhr3aBhurbt49H21Gu5ugh66QVkPz1Fav6YKUnRuVK86zBaXSLS1uacwOUQAhb/zHCaqoboZ/LZzfmg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.303/dotnet-sdk-10.0.303-linux-musl-arm.tar.gz";
        hash = "sha512-JAFVbQSt5udN6qy9m+CMWVRbz73Rub5MPxBtym2RXfN4MBi1rDkxZbsVyRnGj6a5+FWe3fSbOzwZFggWE3NS+w==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.303/dotnet-sdk-10.0.303-linux-musl-arm64.tar.gz";
        hash = "sha512-+C+cEPwSyyYZrR11Ns4hKl6aW5b5SHhzfRamWkdxUdCTs5OJByRTZWLa3D3YkLg3/K6+3b4sw7YdxQdvnEmA2g==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.303/dotnet-sdk-10.0.303-linux-musl-x64.tar.gz";
        hash = "sha512-8R3Z2bTNxSFV0+1uDuFc0ycCZ85AELVuitMwkHYB6gMtUP9JChIwdCAi20hbfTfPYVzH3mp6Q4sbZ+8Rxgz0NQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.303/dotnet-sdk-10.0.303-osx-arm64.tar.gz";
        hash = "sha512-mx8FZkZU8zkJC94bZODtwS6BQBLcOJih0Bh2xldU7xjVnsfdmEBdnGumznNWlt+pat2JzX9MUWNuIgDozWkdEA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.303/dotnet-sdk-10.0.303-osx-x64.tar.gz";
        hash = "sha512-/fpNITzqEX6CUZwDb6Tdr1YXpABOuvajqwgL+j6yhuE7lEw25kkiJRbsrYtkNzDoLdlrlkkZwoVN8h4k1UOPTQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.111";
    srcs = {
      linux-riscv64 = {
        url = "https://github.com/liberodark/dotnet_riscv/releases/download/10.0.111/dotnet-sdk-10.0.111-linux-riscv64.tar.gz";
        hash = "sha512-+dA0vf63mVr1JREoVfK4c+qE8vgAdm/6jAFAyLGPiAPnbgUS8IjANEVolug/xPks3/bjpYEFx9+cRA3UWi0inA==";
      };
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.111/dotnet-sdk-10.0.111-linux-arm.tar.gz";
        hash = "sha512-bO1NgOUKKzueqFnvD/LGOAGL4hlQdIckm6F4O78v1uq8G9jtYKVlKIkNbrNvSEu1tk5KcmViMh+mrvaIy6CC4g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.111/dotnet-sdk-10.0.111-linux-arm64.tar.gz";
        hash = "sha512-HhFd24UJUNRRTWo7MrLReyQKTw9As3IC305b32gyoOVGci5r+bntfffMyzTfX15IvLB1Mi+wGBW//G6cI5mfDg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.111/dotnet-sdk-10.0.111-linux-x64.tar.gz";
        hash = "sha512-quIhvpajtRDVtv/+/GnYrS+llaFDAplBkxa7ccZfJgpFfKmvJNBE4XCbKKkRh5jKr+xTXM/lj3dnxay3NcADkg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.111/dotnet-sdk-10.0.111-linux-musl-arm.tar.gz";
        hash = "sha512-EGWk1vrme8zi69HqwOn5tIjysjmDMe/zs4Za0VnNnSXvGZD86F40Nedha7zM0ChmgTsLp2h0977M/mtpKIl2ew==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.111/dotnet-sdk-10.0.111-linux-musl-arm64.tar.gz";
        hash = "sha512-S53Lz53zMUUQKrvFfdw980yuDXndyzW+JQT9ESqV+MLd80bHp64cwnGIvUSdxxd+Q4t5tSq9aySeLcZnswgcLQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.111/dotnet-sdk-10.0.111-linux-musl-x64.tar.gz";
        hash = "sha512-JRZKSkrANlDbe3SCDylJh+ZPNdd5dvoHDix5As92+K5ta31Vqz0QsnRyaMwDmtTsuIXINXzWEfZXDbxOiqj2hA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.111/dotnet-sdk-10.0.111-osx-arm64.tar.gz";
        hash = "sha512-AjEkZ46Lubpobi8oe8zxTCvfRmrrEUgZrkJWqO7USk+7iIpXruHwd7gHD6WMYR/TOwvolPyLDKsuzkrc1APqMQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.111/dotnet-sdk-10.0.111-osx-x64.tar.gz";
        hash = "sha512-lUlhjlnGFd1H4v08XYl8b738Sjzj1pKPmdy/UeMgI1lUGp029ixs2NDtMqphu8TsGRsRRtQc9fsRIfA+dvSEtg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0 = sdk_10_0_4xx;
}
