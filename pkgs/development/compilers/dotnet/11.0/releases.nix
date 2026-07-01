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
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "11.0.0-preview.5.26302.115";
      hash = "sha512-LkRNU1kmkd6i1FNom4LfNnYhW08c898zFi3orZq8YDXLs4XXXChu+7GMWpB3tq4MKSOaPia7Li6QY12NhhS+ag==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "11.0.0-preview.5.26302.115";
      hash = "sha512-YSSBuR4vqWMxf4IFoRaKKjzCJMAd91QX+QEOSDxcA7wP+5HMsvxy/T1OxDPG4vpUbm3JeDYMPqGtM3ugnX0JfA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "11.0.0-preview.5.26302.115";
      hash = "sha512-KsSEt7ULQEaUMTVt5JclATUwElnlTnm4GUFMHwW62QgmVic14HLPY9q/MozQfD6dOeXNoHTMm9IGs4gzR0b0xg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "11.0.0-preview.5.26302.115";
      hash = "sha512-16anh5wbcRpV0Dm2nZHURKka5JSL1VjMIlG4xD2NwYfXaI4ZSUknKttRhjH1TE1V70+d/XbwgbAfmCI7GNLK6A==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "11.0.0-preview.5.26302.115";
      hash = "sha512-m/2/rJ+WvjDz6HkvZ68YnM0dyPJxlZ6uQ633a8hZE2e8zJB3xmDPcqLNmXFSfJ5xxLp9auDJM/t50OTxaJvAeA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "11.0.0-preview.5.26302.115";
      hash = "sha512-QhvtL8dNIZ8AdqPaAtu/nKWSYIK+6H9A4/W1Ga5kw9T8qx7I+DtGfeNZtFBqos7m1Lub3s0k6Wrg/ZwV05sRaQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-dcsOs6D/588d9HAjKTyuQ0Fh73Za+NhstgALb9gT2Jw1xMK8Di74NzEp7tA10oEEMnI/UpoH9yxY/jLGw4+BCg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-QN3pGDNWhfBszzDgoXtYiN2hvr6+/Orjdm9xcurMMSdqXkopIhFLYxMpfQYUZfh9wlP1YvNpahAMICTbu5HmvQ==";
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
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-M0AMDxwNGXl56MCQJcz+AYlCffC/n5TuFkePhJ6Ku1v4JMQZi6FHPEcOYCbCLiiopPRFurWLYTgViivb9FJaHA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-JrNbcJtQxqX61ymadWhFiifKJjzaHJmkCLZxGSXvn0nSLYHlQvoQ0U/s/oQJVZkj7mvCGEu5dMt7aYGrIxW4Xw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-OQo8B4KDnpOti5f6gPve358oJ8t2vJu6nvuaMfQKAel3xN+Iw3qq7YTpxQR94H4wU24UjzAQUMZYNcnTTifoyQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-WtcOQwXszVhXI3T6QBtNzUJXCFPxA3vVrdpoCwteuFnPBtJpB0+o7EwJ9qnqBH1lJ5HumjGMHPaQFX9a7XL6Lg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-vjdFZLJMKJCH8sowcrHuhzctfoFECZVy/R+A6tL6O8vRwCAu0mOU9TU5vlNORsz4PP0gdlY8/DySILLUGZPSGg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-hfRqLXy/WiqYsBZ93E1oqKB2WQHbntY1ldMf15nEpVCQGNHcVtcQj16VEwBZioBKkiudBlOHenkHIAVLXLFGpA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-vxS7OGgyQqbhg2UMM7+SeonVfbciQVO7lwZDjhXEFWs4dp17gR/qtMUFSaZ25Pxp0jEcjrv36fKuHUuwsF/yJQ==";
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
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-arbobGEm7VrH9NcSsBEYrlBBLjU6DWwj7eRJZ+R555uhhQLl2QFMvC2Ml+ZHAZEhGikiZDsnAQv+lBE0OZS2JQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-Xr+z+RxQsWtjMzXbDPKVugBOUzLjMBI5oBR4by7og5A9Cq1AMbdyLRwBZbDaNq/MCyJoY5Udt6I3ysd6xtysWA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-i0ez+ApppwM+d7Uivo8qrsM9yEuAeqY5LkzSGObQ1JlkTKpt4CUAurJ4tDXaC9sh1NvCSFaHihn5H3sMrnWdYQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-65dRr1sz42wZhAZq2/ksspndEiefcWlh+52ofZgjnsaBPOWmN1JaiNsqTqDOT+UxqErGdD902TNUxYIs0kvNKA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-kZdCpYdvpTNFdaTjWCz5Lk1GIX3l7xR95MSJXsPiHvqXz1lo9EIo38hft/+dtXnmVa8SFeeEOAV3Y6fkY9IIzg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-kAOGTUlXJ1BYYjk6Sa7t/5u7NCT73BRFQIXPqZu2Cf4xoHmFJWwDa3XUqDotk/HiIAeUBevEeFb7n1L1rAN79Q==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-47xQznxIkU+o7NTX7mrMBeHKx1PX0M0zaGaA6nMAMWlyMsMupblv549gr0ar177OuREAIFbiAZ12f/PicbSihw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-XxClKbq2h9n0o2pnLI2pbcMWmHbYfml7hFNdYnjFxZEiSEm9MTMqRU8ECX48tHkG1Dzg/cQ/PWKorzoc+/ZCfg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-UU81g4YFW2Q6MLv4DXFV0C1zhAc1cqttqAtFGvFvtZKwlYYw4SZ2VKdOp8ySPHvNOUGUMqDEFa3XRl6dXew6RA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-niEn2TTTgyK2ubSdGIFkRCmE0Lb0I7jQY9Baxwomyfq/vwyCUZAzY0QoLrEodIBP+O6aBDazREl376hlpJDJww==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-frShD1p4WRxFM4n9Deo56CxxJcRTu4qX1GIQsqdYn+xGZGOV/lNEzYESwD+CklVMVQEmxwGJunguZMDjz0qvUg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-Dr+Q6HaY17FkgE+d7pUH32Qg9kTwgQxmkOIJtvGPbW5f2YEJo9fympPpuDle6J2Ugc3FXE50Ps8/mtJWKLEA8w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-Ew9Q+zX9icR30U4YemTwv232VgSIWgOCef9UstQMK0e5DM4MdxtWqms4Tl3zgLGUBJ09ODCsjk08ZuSR3cd4gQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-cY83JPcamX+C63hP3JI7ZC2+zCT4Gl/qBSUb7ORrdkmKaTKwf0B+0OLOqrv8lZBZRJNizE6We98qAny3wmHBKA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-TNHJdgdKyQKZm5wg08b42hzDLsVDKRXV/gADPUQROtlp8ZQw6qCZixVkWSq9J50XmgN1dX4qU2cIsQzLZ9nQfA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-wzJQfYVF85C3PWtUegOKOe3HVE87LlcX0rN/7y2n/G5iixxC0SmuUij1ea2b9M2au2VuI7lTrOShkMlraUvgXA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-6AFRIb+J354hGOarw6VQ1pnXS+YT0lW4MHKFsOV/GdBQUqbIuv9YLADWMtICNk18kqjzrwOKimG/Dkn14KSiEA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-YH6nWs2t/qmUttuKG6vs+AD1Zi9tvbaMtSAspA3LGb1ss1tNkNSX9BZ8GQcHi8yK33L1ErULxujezE+Jlq6F8w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-kKd/sxnzRZuFFR1a/dmUzJ499/u3LcJL5tZJKMuqPAZ5XZyCoHyscNYvIFL7R8PA2v4DKLI8wZM7Obbe7qMoLQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-QPDQRCpjJCpYLzndx+9MzWEYHxQm2ZB6CQOb6LO+//bOKgMg7SuAUiGdl5xyhuX/Luq+UeleFLvyetc6aFcqdw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-b5Npf6yAU6RHtAlY4voHkqaCsrDHifFpca359TA2Y79aYZmblPZwR24XQreurUsQi0Avy93ovXwdEk60C5ZSdg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-842ypnFU2jDI+5E4jc5fE7Nocleh27X7POVOW8NVAGJFxHZPIkaRmyOV1bc7Pjb29fxeXvBDSlVYjRMvQFB4qw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-/QJQLd+YM0whp6moD75Ka6YKbmq3o78xU2d3jfGoyKOqfNvlxoyQPqWIoXonhm5JwxBvaYJgNOsaM64JXeytpg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-F7A1NW1qoZbAjDZXvEzP8zWUPpIAu4+Pq+5p7cyP5QpRj1vc9nc1N3tRlrUQF7QnwiIxzLWEl8IXycmvGrt3XQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-7XlpOW9w8z5uJDlydfXWXSfCpbd3QDxYU6fqGbjPHIOWlD+xM5k8NW7NSIQhrMt1yERK0lFynn1euaigmYOBhQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-CMCcK/N4kq3KH5k/XeVzk6Hp38WvTFtKo6/pxmbihbOz2GiWe5jxAgHqsT5GC31nd83nFKUNyFIERFuMs0ZvXw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-kfOT+cK+Bn/NI3gg2n6osjWCzyANfbkqSty2jqjPRE2nwvAi2qECZwPEIwQzORVZpUZwPALiI+J2me2Ka+EIWg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-BlinsBWGXyaf/N96derK9RJ2qeu4F/GdNlpOc+csxMAzYKPXLbiXI3gIPQH/Rx6u7JDGzqIySCuorySTSLA4Cg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-pT9M9Dfi5ZMUkfw/dLvJKgpFljvC/HJt6t/tsK9PCpZNaTYJ2IAVW3lZeZjC1GCmgYC1yljsfRwgrykGk72Gmw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-l2WkyuvhPAOycC03QAxY1LiLuPXQ0+AXDFaIdqyaXCB3JZ3T6+0v2Tk339zMj+xesvrK/IALrusTusCI8hbVEA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-+o5ZCDbyvrFCF9XQGFMMEXtFZszAsggpq1l26+OKt9k4A4Js0dORW0MEs23aBx+yWCbADTM0df1e3qGuIY53jg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-juedEPxXqrLoppfMScKFHG9YAm9R1ieCtIndfXXqfi4qdSNGaeh9jRh4cGeCyDTfZmQfZqcOLB3RfYQzVSOCNA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-NwLRLw0JQYLsk4oCdb2vg7mwP4VETZZ1nlPqHkLWTweJc6ARaGsVQLFq/HVyY6T53+VgjcQhsL8T4af5CSAyQw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-dhiwitI6LdiQzgT6Pvw8xPqWKvBntOlO3pdegptEUnvuRvZ1U6ozMjfqYhFouHPHI4TGvjrEfXI9EW0VL4KQbA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-6t0FIDuT+z1lN+odmKMz9PUnXewSIu1yTrO58D/fAHLMWYcYJAVkFhckB7XignlJJMO1glX5Cx8e+VeK4KGw+A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-BJegJPSYpQI0aGB9OpiKxNnYXR014Sfet7pH4UTS67wBKm6n7905vZglO2Ywa9mwUSssvYPSX5b5+XqmbL4tcw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-7WM98tSzleNfsYOdLvpc2rfGoa84zMBkniev7OZj8ncLtiBoil5Qx94CUJbRxbQFZW8j3SJBSg9s8mOhpHYg1A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-dDUuS+2sJc9tmVv7N4nNlhVYEOJEWa55UObVQf8WyW4eOZAX45yGbPadUPfHR2TKak4Uc/QX/cgMYlmp4cg9LQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-gx+7kVwc8ss60jqk/z1t1YEbyCgjejVy+f4CX5uZLbOCYgqTuY2Yhyp+A3kSvlzXT9dYgRGQsR09tmldG16LYg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-1w0TVsCXHYh7F1/gw+kKLtCiIMe4UaqG+z/LHZ/BfbduTdfObvduPrCpVdPVxBX3hqVc+fu6P+HSoE1sFkkyDw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-HzNyLAng3UKdxZQYWRWSl8soP6eEKV/qgsFY1kopm360+a+9o1x4p45DLywWK/VyoIYx1vI/SmwTtJzLD1EhzA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-CpGRxZBZl/LNFIe11nzjykXJSGIbLWoZGCOn65IC0NhjvfmrTxk+TzfqkeodBNf+kJvqW2hTL1lTreqQbOvKrw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-WZidOMO34FwcS7xhA011/0IM18ogz0S0XJ1GYtdCY/MPV2uoOQYYyNQvovG8ZtB53Pj6uJu+kB50MaHQMTeyDw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-QDozJWDVUn7rVBDvivPwTdFdhxEKNVhJzZaz4HSJyemWznHnn748eBLmix3+oBB2/PCz/IOs65NjNHmxDskEzg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-ShfUL3M0QNa/BmXlibiUWFYcPX3PhZ+Ge3647pCwDVbPk7gcg0DWhTiFoU1+Xk92XATYBQdJu0n4r0B7J6vr5g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-ZgyxosAXTjkgsdoHgDbTIiwgQ/7wgsHdIzxKryFRHZfMU40gsCdlpWoRQWPOaRvHhnPpuRxOaQh3PdXBIcp1Bg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-C7DeoYqRuQHwm//bDKdC4CT7pUStvaKihawt2Or59TANdp52d1fMC+yYOeJQ0mE+6dyJTqHlrBFd1IGl1SanLg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-O3pcp2+maNxlf3VblTTdR2NhgTwt+hzzxkE5tZD6DzH/wldYUsCtkDM3SGYG5Ntjg/erSa8XK5KCg/oDA7QOKg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-D56CcQ4l+iRDxXiwX1D0+2iZQenG16YWN+hU5BXL7GnGnYHX+5kG4ltMAWoegiGmesuFsthopnTQ5UTmtjlTbQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-pn0AyLXyv24JZTnUA2L7Ccmtb0kI2NxINp5pAWP9VseJ3wL5l5KO2uHOwnqsDs0vt1sb67BvMpXcLXvwkgDAAQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-XWbZ6W6b5uMxZc6pDphJhyx/YeweP916btxXq3HMFbPh/XFN5ag47p2KBIv2hKtKggknV74tVUtCcwBFIjm1gQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-b0NTYEelY4q6cOzChDhPvX1Y9OeqB4WPDzY4HDmz5PhiBK0hYxFFbhSn1UbM8TRXe9inC28C9wSBf8cj7kGLRw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-CJ7Ugk1EjhHFGiMSkMv0y1k+GDxUcNG+cC3nT3Lz8Pc1jqajTS2r2uigkFqcAwef45/iUZ4iVEcHbgA8oYYVrw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-pVJPfHRe/QYZBI2L7KOjdVaYMVrJITc55/cxxN500Rv9ODM+s4nAm7XITDPmU8Cv/nseJUPG4uIGd/ugD6fN+Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-c5efK4VIdy5FjfTunql0x3fYzS2iXtVlfKVh2nKbadzJS86LPKs3P7CIv73EJZNR3a7RmYBJ5kUxGmx70zg00w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-C9Bipbj9a87/5Td+9GpEe/157VzSDtdQ1JdFhkNqmUipnt5lnK9O+UZ2UcAEFDdddb7qKAYkw9TGSs2oBDSbOA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-u5nL7y8OqScUX+owhXvpFZOwPerakdd+QRiMutOEx22iIUxZ+PFsrTll3OXK3A6tqujQitO+J0dxrxld1muZhg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-tTv6dH8igXDMVf1buSfrr8ws5IMGffSfDf6e9l9xR3VY+a51/MZBYFbYEevNq6+3yyI2emUMP8VzfffHzIAbLg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-sGq/FIKKrNBrEVPJakDgCAj23WFduqj2jixK2TbjSbv4CyhWZLlPw1m3f0tsM6xL+KshtJ7bO6bWcDPhkxM+NQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-icMaYqi+X84N/PfRDAvk3Ksr6xESB5W+O37UwiKjX4MNKNjOpT+INmw1wePlp7pUeA5o9Naqiu48sFv0zPnXCQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "11.0.0-preview.5.26302.115";
        hash = "sha512-1XJKQNuBjrQO+if0LZ1MRVD1rqRuWJcnWEL4FOCfcgED9pfK8agt+hx2BjfuI0U2oYEVIZUR+og+VhsqlfheDw==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0-preview.5";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0-preview.5.26302.115";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.5.26302.115/aspnetcore-runtime-11.0.0-preview.5.26302.115-linux-arm.tar.gz";
        hash = "sha512-xYkLYTLeLMaJ2zBDwc1/nzL+TgSF0zEmw5xjK9T1RB0DN9eP0LQsdQbnphFI4gz6QCi3nTJyNnaMFHpgKVX37g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.5.26302.115/aspnetcore-runtime-11.0.0-preview.5.26302.115-linux-arm64.tar.gz";
        hash = "sha512-KytVBb87U7MoAXDwzMBaXrcywnhXw1C2r1dxWr9UQu53sGvzGdbQTlki8VCovlJTr1r073koMDuGWit6MQwzTQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.5.26302.115/aspnetcore-runtime-11.0.0-preview.5.26302.115-linux-x64.tar.gz";
        hash = "sha512-caC4T47bdh6oE1hx5fZHaFdmI0l663Fkky3AaKbpsa+pvLXHY2If2/B9np9rggIzIWDCXSuXtL//PH4zzISNwg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.5.26302.115/aspnetcore-runtime-11.0.0-preview.5.26302.115-linux-musl-arm.tar.gz";
        hash = "sha512-ANWpZrcB/qBrIOIyv+0BwWaeJR4Nr/PxUxbAhT8cuzW01MnnoCb92QzOUFZ+/EEzoT2VUFTbxE75a6pOtNkjJg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.5.26302.115/aspnetcore-runtime-11.0.0-preview.5.26302.115-linux-musl-arm64.tar.gz";
        hash = "sha512-SP0OfdJ3SwAh2EXcsyumRf5SfXV6seE3PhT5PGljMkzqZ3q+zDzc40ce+aX+Mtqxw6DYZ0yx6Smtus9KjPxmZA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.5.26302.115/aspnetcore-runtime-11.0.0-preview.5.26302.115-linux-musl-x64.tar.gz";
        hash = "sha512-GuwC36WrjFrKOnO4g9P0IFBLSP46xQQT/d1SGRjLixGQdPWqk+5P9f485ghn8QKlI7kHLnwZggrNH1xGI4Hm1A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.5.26302.115/aspnetcore-runtime-11.0.0-preview.5.26302.115-osx-arm64.tar.gz";
        hash = "sha512-3AgtDYs8vbWlQy75/6RU6EOmdU9P2zxCe96PXfr5KojHwjVYMwGKA0m25qcfWcCLdQzOtDqhRiYGXxT2EqVW4g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.5.26302.115/aspnetcore-runtime-11.0.0-preview.5.26302.115-osx-x64.tar.gz";
        hash = "sha512-R5KG27s8O0+D+NHxOwy3s82Ibi18YoZnKtbCwRquAvZlwHSoo8ltAhf4by5TBIxwrk7FZeuy5dx8RpT1HPY0kQ==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.5.26302.115/aspnetcore-runtime-11.0.0-preview.5.26302.115-win-arm64.tar.gz";
        hash = "sha512-0UPyy9B1UKRhHMH+iLFJR8eLkHe2+E5d4CxQVwl6eyjMs9k5+YiXFoU/BVuLum28V9SkNQtFuTz2K4uEaS70kQ==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.5.26302.115/aspnetcore-runtime-11.0.0-preview.5.26302.115-win-x64.tar.gz";
        hash = "sha512-929R51lUUfTxTTWUUDES96ZbNU/Dmlks03wKeMwJyyMcFX13h1jeO+dJXzLAhHSElUPjS3dsRTetnBb6a+OTTQ==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.5.26302.115/aspnetcore-runtime-11.0.0-preview.5.26302.115-win-x86.tar.gz";
        hash = "sha512-RhPjydJnI+Qb+qp1M09cXYI5n5vWj3vkwE+VZp2Cde7pTzYhbQmk598XZTdTsDZT9GAVUf/0VhF+Gn8WTj2C+w==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0-preview.5.26302.115";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.5.26302.115/dotnet-runtime-11.0.0-preview.5.26302.115-linux-arm.tar.gz";
        hash = "sha512-APeEHdQPkyvWmN+RCGabsXchfGcwrNi6olcPY01CkAWJ4TxZNM+gEzv9hxG2ahYnBWiDh2D4WkR8CIFq6a8b7Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.5.26302.115/dotnet-runtime-11.0.0-preview.5.26302.115-linux-arm64.tar.gz";
        hash = "sha512-YFcHwqNOvDnL47hXQs2MOdcAhAHkJ7Iz9zRJcOM8EpC1Xds871HpiTKjnhb+frMBMtDO4tDGvJLujrhfrmo31w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.5.26302.115/dotnet-runtime-11.0.0-preview.5.26302.115-linux-x64.tar.gz";
        hash = "sha512-34Rag66ck4knFYNkK4N0eZDJWOv/n4yAj3oZX7eK8M3y5vmNVeG0K1dmQ+OjpULm99mKI0JQbyFraWBCLz+ZUQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.5.26302.115/dotnet-runtime-11.0.0-preview.5.26302.115-linux-musl-arm.tar.gz";
        hash = "sha512-+z+A/3vPzAtKwxx4CKLwiZRFILq3i7d1IhXcdoc5I7bNSm6Muoj+hhAxJOCxSJRx8m4IlYYGsg2sVX6tG+FgVQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.5.26302.115/dotnet-runtime-11.0.0-preview.5.26302.115-linux-musl-arm64.tar.gz";
        hash = "sha512-4DJrJ38g6xF94omMyT0wasjOoOuHHpEC79Wx5QFDlL2ilFD7JhJWWiuWn7lOZ0Mc0PgxQO6Q+myqLT3P1qbDTg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.5.26302.115/dotnet-runtime-11.0.0-preview.5.26302.115-linux-musl-x64.tar.gz";
        hash = "sha512-tpxriicKcpgiEFNX1rgVx0P+maxDgaUMJPOsCv1uu8VJ37AsR0uYi2ma6XlujbEBP/8CEX1Svcig2Oy3cZH6UA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.5.26302.115/dotnet-runtime-11.0.0-preview.5.26302.115-osx-arm64.tar.gz";
        hash = "sha512-llr/5a1kNM9FtraO26ceGqiWB/+Ji+chATkyK4nEIHFyRhyn9tDWMuxPywpU9tXUVBfo9ztemk2dYPsawpR2OA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.5.26302.115/dotnet-runtime-11.0.0-preview.5.26302.115-osx-x64.tar.gz";
        hash = "sha512-eZpF5julkFJoc+TQ5dZ7gXb+2wTXcT55B4YGj66WdP8PC1oUWmRqo1aHvkII+5UJ+a/CqLsbph+RUucZ4DzO4Q==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.5.26302.115/dotnet-runtime-11.0.0-preview.5.26302.115-win-arm64.tar.gz";
        hash = "sha512-thTay5LUKP8jdTsfnvpvtDu4t2vI4aC5Wz8NcvKP+mLVeiNQDRR0SVefVS4BbvA/iUNw39jmxMrE+0Mkvfu2xQ==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.5.26302.115/dotnet-runtime-11.0.0-preview.5.26302.115-win-x64.tar.gz";
        hash = "sha512-eSQS1AASCxOtsjDwRHER8bMxdjra+d7wme1Bi6gcc23lTbID2ha/YRrmAitCM1MGY/cjUjpmGHCHdd+KmR08nw==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.5.26302.115/dotnet-runtime-11.0.0-preview.5.26302.115-win-x86.tar.gz";
        hash = "sha512-5OUAhvISV1bBoMVUrcOayk6kx5KpsdV7/zhkFU33unIjS1PwHcpjHRhnbOn3c3Zk5xd/m26R+RLAgTSacoanzg==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100-preview.5.26302.115";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.5.26302.115/dotnet-sdk-11.0.100-preview.5.26302.115-linux-arm.tar.gz";
        hash = "sha512-DMBxgr/NWconeCKJy/VvnC7fAaDZpcV6J1A0J4QCkOwrNVShoXfjFOxo7xup4DPTtnSREJrdvHmEYMw9qYrm/A==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.5.26302.115/dotnet-sdk-11.0.100-preview.5.26302.115-linux-arm64.tar.gz";
        hash = "sha512-f8cw3FmSZRfsxKp2hm58YvUPxzMfCxJ8nXeJOnFpHb5XYmXfX4Qgikz3jmxtF3XNCS2+BcnpxQrwF7s9yUct0A==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.5.26302.115/dotnet-sdk-11.0.100-preview.5.26302.115-linux-x64.tar.gz";
        hash = "sha512-nIk0A5iFjm41vbE3eg9cTYgUGp2tNzA2g8d/b9BJi2pLQ1o0h1r6oCEpg2IuyTeyO4sX41OEAfvb8jTSL4npFw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.5.26302.115/dotnet-sdk-11.0.100-preview.5.26302.115-linux-musl-arm.tar.gz";
        hash = "sha512-qcEJiu1lkfCsVcNLQg7ncGuxxUSkhrZ4xb4OzMS6M5z3nWkwBvO7JrVigs4qk68paf7UdC5uT7P1dNDqT00XRw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.5.26302.115/dotnet-sdk-11.0.100-preview.5.26302.115-linux-musl-arm64.tar.gz";
        hash = "sha512-BKsPhx2ymMhiPWzqx3ycrSY7ArxwtYcmJd26+LXevR+lxknfuBjEfrbX2r6fKKyf0QNNHHdJxDwelDCHwC6JVw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.5.26302.115/dotnet-sdk-11.0.100-preview.5.26302.115-linux-musl-x64.tar.gz";
        hash = "sha512-+Tc0LM8vmYaKsEUTgG/tvmnL77hhbhm+NwFk4uFke2I7MjG5pimbtFdR688T3gQQJr86dxK+pqMbZKQtt5RxyQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.5.26302.115/dotnet-sdk-11.0.100-preview.5.26302.115-osx-arm64.tar.gz";
        hash = "sha512-eftGDRYp9Rb0y19Yu/TV4u1pkLfeXz8Ru8dfKHEkWzmyxLlthjRkbDADX+vailEF4QCHgHi6L3R1/+sLCCOvGw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.5.26302.115/dotnet-sdk-11.0.100-preview.5.26302.115-osx-x64.tar.gz";
        hash = "sha512-/4QQgBRJ0nRhFzNV4W9BcGhLbJcGgjRfVwB8/qQ9Ze/VodliuYgW3hmqExn+DKLOdvMLKczi5N367bsxaQSbSg==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.5.26302.115/dotnet-sdk-11.0.100-preview.5.26302.115-win-arm64.tar.gz";
        hash = "sha512-gkAhLWUnQEQ5KSz9XPviVPB82ekAn8ZA9E43d/LlDxc2njOZ9nm2hGOx/4X0REhGT8301RkfGTY1y4W6OgGz+g==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.5.26302.115/dotnet-sdk-11.0.100-preview.5.26302.115-win-x64.tar.gz";
        hash = "sha512-7TG78UwES7xwiZmNxnBhBOvwxqKQ9UOhwjk5Loz4uXowGHtQMP6jKITNHc0C34F1JiBr3cmZZTRGCoSijoRGbg==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.5.26302.115/dotnet-sdk-11.0.100-preview.5.26302.115-win-x86.tar.gz";
        hash = "sha512-gXhe7UQ3A1pBxskCaBZ7vbbrmQttkVlhdl+uEzdqh2rNg0a9sRvJSWf66sMEmOxtGtKTwb3f8+bwlDyVFZXBCA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk_11_0 = sdk_11_0_1xx;
}
