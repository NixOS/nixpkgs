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
      version = "10.0.2";
      hash = "sha512-MeDkxsB9ir694B2z0nIG7ZZ6DISLmbU7aOwCusO6AadYjitxjv+e9TuY1Y0ijwuYNjxukBIj45nF/fCEg6CGHw==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "10.0.2";
      hash = "sha512-v9Au9ZSo3ZOe77StttCPCtOZkY7xSFXSyyWMR9Y0Kx3ZKegVp4zg7TJwz4osTgQp7EKyXlbDpvjUbgly51XbmA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.2";
      hash = "sha512-dlgigLX+tCuYRg5TcnOTg+UyNlIK0queBF5EWmPw8jpX3J0iqXUs9Nb+4BriG57QoNRiZCXaEB81TDeKb56xxw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.2";
      hash = "sha512-3qJ+azj6rd+xEpGVoCtpDr1p83IVLIJEZkXo8EtPWB8HjZlrfh7MA6FcJM8bEhqijqSy10yzeoJY0uyB0Dgeug==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.2";
      hash = "sha512-Lbk2KbxuXgn2iW+VjbXYUD33w5EDgNXwLrBQ6KeHDMria/x9SYqf080/wvto4Ot2La2gMgvbwS7WJ9IE08ydNA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.2";
      hash = "sha512-Q1ZYQ+2IEDcc6Oh2C7VehfmMUUbwWle4SmVVfb5o7MjPPfj7ns2s5OYuPpcAupkCluuIEo4qHgwZMDCAIKVxkw==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.2";
        hash = "sha512-fpiV9uvvIvfIPK5AirdUyteKq4+zSpA0uEXQu02HKumxOti1xxDhvUV5m5iEzDwuPr1AbUW/iHt40F01QUebPw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.2";
        hash = "sha512-D519AZE0AC3AiCtXJOwFUil10/0dm/uhykgje8fm+tWZEftGeOwqeyvG/FqT2T+UJItJ2X2agymdGXmsF9sw9A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.2";
        hash = "sha512-jvPzoK4Lw6lZWdsTDIAa2dImRmHvN9mbkuvrvUriz7qTQPhaWsqC9p50VMrO5LYZCxCcLEw+crXSQb/paAQgrg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.2";
        hash = "sha512-51ko4yV4GrGuS/U+8eYxWWc/ib3KN+ZOdJmH4roHgWw/MRIAfezlGkQAwMmt7Fnd3OjCT2aVBuIcYKbtnplIhA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.2";
        hash = "sha512-DAZWcPotgFzYAbYIS4zPq8Be/tWLtif7wC9LIXukGChz2F+fHpWv4r9OaOPTf8hCmQQAb4xeuMtOP6O5msoVDg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.2";
        hash = "sha512-msYQCjOIO9huZemPRdDi2dabKKr0wSKlCtzFdPZwSDWYfiOasgFrgsHXa4BC1zgw30ZEWaEFIwrHU6QFjLQqEQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.2";
        hash = "sha512-jH1v8wgrHaT0FnHgEPpVCM60TPHvZC0nL/o5cMLIMBJ7DI0XZM2vkei8JqyADR6ivTzXBpfj2Dquou2eA0AOzA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.2";
        hash = "sha512-W1DaAuDLiaVjBTlJzKcWeavvCa/Umlo3fqgrOAR/UqgF6OSwBX6Z2FkTiZ+hpeeMQ1nKUwx1pcDepx1CauBrag==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.2";
        hash = "sha512-0oMz97/sUtkQcANOcZ3SicPwA3qR+yjIl7EF/lokGCGwa9MN/2IRaTxgCVmT2or7ijb4bTMns8i+S33V3ngD2g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.2";
        hash = "sha512-u+Nacy3It5swHvm1HtdhNEoYZpI9VTvwEkZ0aH08MCKG+5I+M4eL9axO6ZS6NeQQ8ZqYvuCagNytar+QR2bihQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.2";
        hash = "sha512-yYMtp3DzEgOKnYaXZ4xDlaqJEIIKbyrKgZdwvbTivKdtP9v+oRja5CE9EaLjnrHpb4DXJx3RhrU4CxteCtStAw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.2";
        hash = "sha512-qPGQVJUzn/x4r4CEnAR2gQWpxoxrC0i/PB/3ra/p56L8T2gPQDndpCT5lYG95c+IBk5qBZCzYVCp89iSj4L95A==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.2";
        hash = "sha512-nl8eKSnKKy+58OA1L5JdjEUUZmfYAetCHa2ub8tr3COZSVsGVon6sPpAZ5DQUSajIPSt7NRekyEr7m3XDX5Rkg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.2";
        hash = "sha512-N3CTQx6CxHEwMkoYAhDY3w1XjzSPvqwSy42RkgyFx3FT8cU247A8zcGXJCsXI7yMy0BiOtdzj4I6s+chpo6aJA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.2";
        hash = "sha512-O4x4qz2KLev6o6FYGIckFc+CdCsN0qaDMjlzJlrPbVqWeJHcBTNj5FNTPzDUxCXMPMRX5H5Asd7wpTWc2ZjQJg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.2";
        hash = "sha512-hqL6zDVP/dnETdj5TzZnee3TFtUibpvwN9FxAWMtwZZo8eCVgIuOjem3s1SPgRuiTRHWsWu8gWNDd3Dm8qn2zg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.2";
        hash = "sha512-ITRkUIkX5aQ1s00vQ1Np5H2P7lA+rk7CIF9Zz6emWa+GTjegLZ4gBAlWQ4hbn4eWI0ba3WVeTTq0t7WPlTTTDg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.2";
        hash = "sha512-iVH5Au3lt+K3HLICU+SXfwiU8MENdLRCmsn7TTu2JVp/SZSceU/vtYC5akQNgzJkKi412w0oEFOdb6aLvcc3PQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.2";
        hash = "sha512-2wmzupkSnGroRzJYepMPELNaXO3fgzz4L/PAkwpvWt5NVFHTDU7lGymPLrBf2lc9U7LCuvuP7qMalx715QvrBA==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.2";
        hash = "sha512-/o0jAyZjkAhxUF1iaDiMDlemKcwXLIpKW3yGmLcwdJKOL6X31flCYRHVeCGlL5cFjuAaBc/vDRKyoI2c2MVTKQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.2";
        hash = "sha512-4K12mMTIbnRWz3sbQPT2hRrvnsP9EcygayHZcxpVslkzbtb0XGNhAT4qNMHdEeH+BrPqBKaupwgXiQZtZzMClg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.2";
        hash = "sha512-JpQdRvo/yReV1WrXN0CzrPoSzcigPTb4N1meEN226hqt7xk2fcvAXJMDntD5eENo/hZ2r7X/rggckjKLzXbLyA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.2";
        hash = "sha512-QnECS7RZxZKTFEQiufnP3yGKSMKI/9F2Yqa019lCqug9TXO+pbB0coD0nUQ75GpoDj8dMj50SqYM73O0nwrJ7A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.2";
        hash = "sha512-8plD8Sq9pRfGdJ1xaWJmmk4wvo5LoLps5g0H/D1ahCKf6Bs4BuquxcyVfAHKsZ94/Gs/zACWS1FRKsh4mTCS4g==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.2";
        hash = "sha512-Yohi+HtziOv3WP39Rm3Fjb1gttgfjj2Mpk1oFkVuYgxe91Bjyt8veSSmzt4tKLmcTUXr/+TUuA0lx/PftHiPJw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.2";
        hash = "sha512-SmXNApTrb4RHUSfYgS1rNr9jzPHZEnqr1a/5O5ZU6YWx2puq6lUS5H2eTz+EPHaL5XTfVwl39FdtKyIdqs4I/Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.2";
        hash = "sha512-+FPjH0FOqU75qsQlAyDaGKGEwFmwnVtNE0QtugoKqMwP3rJYWnfAE2DA84VuaeKPUh0ugTRiez1KVxhP9lKM9Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.2";
        hash = "sha512-LdmCx4BlhGWqVExa6/oumt89+Izs9V4MyepRKlUpja0O/XYIBX7mLaVZ0Leq179YUk3eUs0TvFT9WlrbT2+WrQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.2";
        hash = "sha512-pKVDUKAhaRpGdTqvvN7NyLKuoJvOHMNOdPe7/zMk4mbMnyZc2LYR8ykkkV1LNZQoQW92B6owAgKlzGg3brv/jg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.2";
        hash = "sha512-j53o/jrNB3/VLkS0N7QIXbHuLLiS9zc6gmICM2ggyvhlyXaMQBUcvu1vXKKJztd2C81CM0aq9j9CU/ygcXLILg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.2";
        hash = "sha512-7uxI/o0jaZ7lBU0Cpxxl/77ap6+sOfCPPAkOpE+irQ3GxtR8675pZElHrvBA6Eq32Ig0YaDwcpiJ85GPL1f2ow==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.2";
        hash = "sha512-cH59TAPzM+uVBL1OjTFFDMUneXhwjzWojSTgfoU6HVGY4GB78wFIwD9sEBB+abBT0akbP4p+ZfUNp4JKMwVRwA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.2";
        hash = "sha512-EYswiTzkKJK3L22U9nsHLvsdJOelsguYi7gq+slxwj0PZDdkU9zw7F1PeZGxX6MS+rDuDqLZ3ipXEudSD2NQGw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.2";
        hash = "sha512-kvxx2LqSLIUYPP7uFi/lQ+wY3p+OLHhRW/YwsQjJqrM/Rj/ApMw4l/GmWG+Mwyb329kUCog3pZNd5l8Ki/bxKw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.2";
        hash = "sha512-Xa2h2ZBs+vKW0L9oPM/5NxH6JS+GlN1nvKgOk42sNBAgdrh8nPF7J6fL2ZAclXMQc7EGkPS2vrFYhx2tENvH8g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.2";
        hash = "sha512-NpiSoJv/uYjvVBPn9U1v3LaoaGCN+4+UQbKRZ/rH2ZqUABHnKHEfdUPfaLscOONdYjD6mxGcvNitZqrGn2NkCA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.2";
        hash = "sha512-Vs82EOZFQd5YyiwV1KL9BPh8tWzXa5mvXXLVDHRoWqVUXdQBBsQUR7pd2kSYy1Mx2VW9gIqyxlA49NAIy1U8qQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.2";
        hash = "sha512-bImG3W3xvOzoR/JqlH4xtIthWeyYs30m6Y1cGYnygNKVD3EBfeLNN0cWWJbp59kZcDJ1K2UJAkG/5YAawGt7vg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.2";
        hash = "sha512-0dm33n+2EZwRxS1ZzqdA6rw0sLYFCWw9cmAZYO8A9Qev/5neG9oVLVEm0l+caC+kkkrLiMkEdzxc9Iudc9Sb3w==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.2";
        hash = "sha512-qx8zKUGwHneBu6eYEuXGjkYRdhGvfTl/hZ0OJ8s86rKZRGlIWuCUlDx68eW+1wK5SxqTLEgqgjq0bvkq3D+rGg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.2";
        hash = "sha512-ekzeTBQ5DB5XVvj2umshjXXB5id8hQLAKdDtxS9NCFkdJBccBA/sraSpqp9u7wMLtcPlXWOASFCwS6h81L3Dvg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.2";
        hash = "sha512-YdkF2zZqU3+7SVZb4tofbryj9kumZqUTtmvoFVGnuN4GUQteXkJYPYfyPUmzTJf04+e6uGjlsC5J6D2BkXxjSQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.2";
        hash = "sha512-iysJBEOAOvEsEbw/XIqnsyb11ypiT1tsiO6LHK6hfqEp/CzMDu92HLGMwt1jydxneItCyAnPXN+Tod194uRShQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.2";
        hash = "sha512-oGTR6mRZiejQJJwRuOWQGUXbgA0VFnJ6gXvtIbJ2MqyGJ3CdnPQXfXjcugPOLQv6anGwv5ycPSgnJ8LhlbbSkQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.2";
        hash = "sha512-2+Km8yDt08pAw2A2Vj+NrecNe/nOXORo+PQ3zZey31SsG1ZHInWgDMGAmumrhoTHlddKQB4gutJOXNsm0eladw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.2";
        hash = "sha512-Q9RwIBiRsu14iuf5j5cGN7tX4w86KzYs7sEB+z/ljPy8YajaKub5OWkKFpK/D/eoGQwfQ8G0hlYWLJSQ1Myhyw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.2";
        hash = "sha512-XkH9MRV6B4dxnndADS2hSU9m2eHZD9b8KNn+OUuuxdeSW0FsA3QeEilHbqw5PcCKVgwW+R4fNnTJUuNJg1KhKA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.2";
        hash = "sha512-yxPz87vqvsaWs86eiDgvTZ9y6bg59eQoQXIWONAGX2ZCgzh93f26vpbMqnrwDV21aJv+VIabfo06eLehCGcMMg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.2";
        hash = "sha512-hz/T704PkGX0SgQCuWR3G0IiqoVerAeTU+2pMP1lwdDjvBWUM7WJqQFUYtkwhgBchwmDt16i8xyC5sQh4nj/AA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.2";
        hash = "sha512-uVsmW81TSWHwcLczyP/b4XfM+dvmuK3z1dqBUUXFaIxWdTRgZj2NNdj+6+7IB4oYbuHrPVRCr/KSZZvgaRjFQA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.2";
        hash = "sha512-JRYATohpyzJYqYmogrlCb7aw4jR4Tyg54QQClPTMM8VRcZmWpP0vosV013MFigLRZh/HudZS3wifIiejamsqMg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.2";
        hash = "sha512-zM3+pQ2Mw/HKEnxSfUGmC+3cMv63irWkTHjm9fmcxbGP1iEhATvix7LFeM02n1xAY5E4nEAddRsOYS16nsaE3A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.2";
        hash = "sha512-uQxkmfdQxKIBqaX4FwRjeeTAJIbjKyNFC9gjCqIg1o8x6HhnHkhUGCpm2S0oekf6/HPuJuCFDqfW2285N3pffg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.2";
        hash = "sha512-5fAbHxsLlD8Q+kpXY9uGkzpqpBseTSUvsvg60LYqg/u26nHEQ94qnePsLakoe/L6GAeZEbpNWlX03yb/KPdgQw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.2";
        hash = "sha512-ntZYKY843uFBZTfDSs0wGEc5NA4DAN0bG4qYJhbjK71y0A1k64nh9/h+EgZaC8Iv/X9peBAu7BqiVveeVBM+BQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.2";
        hash = "sha512-mspuFi6Bb7a6U/Yj0YIMIHKKUuIXMU/a7BZEdTYrQ51GKM7KiiCkQeduudaA9g9kMuXisEpNLgSxwSRTyyC23w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.2";
        hash = "sha512-CoAL+2H0G83cFvR1kJmmLT9cmS4FKg0iAbhhcSnPfnF09/Cw++z8vmW5g9QSrSuXJQOqnwcDzZvhfonpPkYnhw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.2";
        hash = "sha512-4eSx/T57ImkGZEeybh1M1uUdkN5UFJnx8TXGRR4xDFv6ih1pd/msTSxyoE7pq1Mx4BQG53ai8IRjCEt+Rou0gQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.2";
        hash = "sha512-ca1S6b1HsUIv++ryZ0dyD0V/OZhgzCIn+cZ7nEkLxYk5r8XhYcoFUr2ST5Ij8rBuWedxXZo3/xXgMj2uk4o1gg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.2";
        hash = "sha512-3YiUtVeAh2d6ppaKiHESTipjRn9J+EoRswCqBkY+y56VU38667ki21L9G6Qtnuim/wGUoBJRiEUhHwxyzI9aGg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.2";
        hash = "sha512-1R9u/bZ2HFLAm2YMp3EvfwvfTk2M+OVtsXQ6nunOPFUFwR35oPFh0uzxz7dVRC8oJVUw6xKGh0+miqMIfSQF7g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.2";
        hash = "sha512-2//Y+ZXy4cnI05lZRR6K6aK62nbTXxKc72YQ1o5zfevEZh45ddfa7hoxAEwOtHUUAY/bNW098C5jduKFIdHfWw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.2";
        hash = "sha512-klu93uPOOXH0IFXcUzsX1SO3iixpQJep0O+EvI8ZejUqCzVscZxaLhdPo2RESZ3ZQ93PisqaOURIegxPetV6bA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.2";
        hash = "sha512-ELDgqORIXfWu2d2NdNhaPgxMdl1lz5msGcyHB4DUaHhMj5loHvHO+1bEzoKH/CNhm8w+4bJUlv5n8/05WvrfIQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.2";
        hash = "sha512-Bl48t37sVydjn2l5TYPABBSninGzESRnCnvUIQYF5id6nv4rqjyhvKhoSb7voWa2yPJav+FsIMIGAro+2imfgQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.2";
        hash = "sha512-d2bxCX6NFCcMYTNbZ0Oy6I56ajoz4sf+dOMujtZXPdEny8x1VXmlnOPduNbJJ1SsU0mn2KuBxal+aXXAoiFQrw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.2";
        hash = "sha512-VTUGNbYiXId/gSmlS7n7e5PDvT48exI0iSypc6dmBdFF1n76VckUImWsee4qKv1rYND5+HxjpDgI/QBJZNThBQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.2";
        hash = "sha512-QydAFZqEkCKSBKGHx0sfVeBeUSDIRX8y5/aUo9ntuMxMIKmkOhsYBr8sAhJogFBWF6ehhi2R5+m2v/H3fJmziw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.2";
        hash = "sha512-azfXCpSBFyf+5MUNN1IjkfcT/gLh80Ax0+oL6jdhHbCTmTtz83L82rYOS7UuHpm+OHa11AuY+9cOwk22GOS1cw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.2";
        hash = "sha512-/dNKatBdluzzBp1wxJ2XDpii1B6W5Jp6G6BjjFkgLQigeLyS4vfTmmvMhoc8dMxVPv90qBLMBvihJOxKMOol7g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.2";
        hash = "sha512-RQ6TKhWakOaRkDj3SRnzl14BsMYvFqIrSdPlhYSndryEtFm4kqHPAGzdx/L4keNzmF+vBjqOr1mcoFbPvn+Ppw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.2";
        hash = "sha512-cHw6gtxugKdA0TtJfxBfeBG+AZV5iu84Rmztir92tDETWHqKkWGN7P7YzPFvbvuZyqsRQ4576ml+HabKzxOSlQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.2";
        hash = "sha512-l2sFg6gy4/6cjIi0f2DrInKf3os7uUXKoR2MUnA+Xk8SHegj/4P36yDYk5hAJSK6eSuJvChacT0gYanjxyXo6g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.2";
        hash = "sha512-WfNDz4vH7FIptb4Gpdm1emxBDmmEbOZPRx+Pj8dYGWU5fp7NUxoH02Py+aDjo8bQ/oRfWEiNktMNlvzrb5cJcw==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.2";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.2";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.2/aspnetcore-runtime-10.0.2-linux-arm.tar.gz";
        hash = "sha512-H5JnanfShBkCzbPuQJ7m2gknjOlK/kxv8v/NOogkOVvycotN4cBYnhpgb8GZL6NGBv3aQmnbdYOCZd53pZhRRg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.2/aspnetcore-runtime-10.0.2-linux-arm64.tar.gz";
        hash = "sha512-UuyBSS1tQlPADX9R8S1f3bECUs5mTbAgxKkORDPn63hiUpc3QA1YYvb7pByyvPIj+ALgHRlLgpCM6EUwsDgAsQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.2/aspnetcore-runtime-10.0.2-linux-x64.tar.gz";
        hash = "sha512-Qez+am755YeljxM2/mZ+kFhfC8oiJ+JdDek0DGNJZ7GA74x8k6Yf45CUmp/dweZWunF7wTL2lH5uRQ/PxJZgIA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.2/aspnetcore-runtime-10.0.2-linux-musl-arm.tar.gz";
        hash = "sha512-Ow3eDGvpNdp5qT7oOIUCk1kUuFLYN/7NORweVdovP8dmzEgxDXjT4HnFAZJOwTeyILhUaYkxndVGL9BEalh14g==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.2/aspnetcore-runtime-10.0.2-linux-musl-arm64.tar.gz";
        hash = "sha512-Kk7JYczua1zWK7i4Phbfyw10TJqY5LYx/rn4Iti/x+DNlb2kTwNGQ20AdafDMMFEZPIANiAjkmbe2vEnvLedhA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.2/aspnetcore-runtime-10.0.2-linux-musl-x64.tar.gz";
        hash = "sha512-eo7hBF/j0ADJkTNmcj38DZ8GmslYJB4WWPwnrM49FpIudC8PX4AMocIT/JYg5kYucOt2M7SoJx/gl35B9rPs3w==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.2/aspnetcore-runtime-10.0.2-osx-arm64.tar.gz";
        hash = "sha512-fmslTLilSOWRYaMTNqdffb0hSGzXV1zAjU2CaEutmkI1KAb2c/fe7zuKG/tPGwhv0jBWWnkSXx3TLEkSqwuzgA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.2/aspnetcore-runtime-10.0.2-osx-x64.tar.gz";
        hash = "sha512-jDQunYnuv48DulaNg2UtHqOrYeyLge6K9xS3WynIUHYtx4gOnevLSWrtntnDIcogI3xLG2pMM1b0ku7HyaOdsQ==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.2";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.2/dotnet-runtime-10.0.2-linux-arm.tar.gz";
        hash = "sha512-z5i5zxRho0UPESyJZvhAnwGtff2EHO+PVIMQCm/a/zubb7tBsNWyNa5AIceyslQjMhfCmnYv9EQ30c5jqNGlRQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.2/dotnet-runtime-10.0.2-linux-arm64.tar.gz";
        hash = "sha512-WS8dyTkQ5E+A47iO2hsf6IWfAHhvnSk4+bxMFHAOdHgFXaRG9lz98YYLZ1dudkWdFsAtObfw9RJh/03QDRMO3w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.2/dotnet-runtime-10.0.2-linux-x64.tar.gz";
        hash = "sha512-KAlMAxqH84THTqhVxl8XJIL2MkP1+HPbVU4DPmg6yBcU+mVNyNjXgEQHKWlWewkz9HzqaZ3q/TDZb0D07iT4UQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.2/dotnet-runtime-10.0.2-linux-musl-arm.tar.gz";
        hash = "sha512-SX+8LjqfuG9dRXYHESBR3p8WFM/Sy4Y1Miqv0yIYLrZx8Cs8PB1gT/hxtO7CcJuCE/x7xYrqqddrMFQIOF0udg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.2/dotnet-runtime-10.0.2-linux-musl-arm64.tar.gz";
        hash = "sha512-7LkzhT8ktz+320FnLl8umF2NIyO6nm+lW3TYl7C4G2O+H97FiA0qTLwiRXyn8JZQY9FtgG2sDSbEq5udOqoO6Q==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.2/dotnet-runtime-10.0.2-linux-musl-x64.tar.gz";
        hash = "sha512-aOcfikL1nvZWCqD6WDKL2+EUjUzK/o5qP4wyebU73VA2qdbW7CsjTcdNYmA7SXyqub66zi73uCYYRNqdyPDxZA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.2/dotnet-runtime-10.0.2-osx-arm64.tar.gz";
        hash = "sha512-1DgZKrtJRYZgsHfrYhyj6JWlidtCA+LDeXjJfLzlFyMhjl4PAHjRjF24a0miZRNwPJNkRNb3ELoJPMioN/hXyw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.2/dotnet-runtime-10.0.2-osx-x64.tar.gz";
        hash = "sha512-EII395s6S8V1o/SMjec4/GtnZFyXpUZUMSFSD2/h3extpdhCRxWHCxzrlpZjFE5KbiSEFKKi6TUJNFqHrR1QFQ==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.102";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.102/dotnet-sdk-10.0.102-linux-arm.tar.gz";
        hash = "sha512-oo7/9bGAs5EvJsZcSAKs2WH6LXUaLMKJulcnrnAlPXCCW61O0GAZp2AapUIB1GZrbcrLmGmw/UVGa59bJdbRXw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.102/dotnet-sdk-10.0.102-linux-arm64.tar.gz";
        hash = "sha512-ElQUEVPSm1uSbg57CxcqJfnAlrjtahgvVAYsXgtBOEsw4Q4r8evobtD1j0/3YiA6zYO88j/vtZwHr0UzLXlHAA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.102/dotnet-sdk-10.0.102-linux-x64.tar.gz";
        hash = "sha512-et9A6OVUeXA5HPvkdMOHTGkYzjV1rDmPN2x4UCE04cii+j2prKKB/a7agWcfVshR6+nnTFtXxaKYvUXeumNWXQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.102/dotnet-sdk-10.0.102-linux-musl-arm.tar.gz";
        hash = "sha512-dex5Yn41X5Ya34sybyhU/psqnVQmqoJiKMg9umdGv52VWPG0n0Q1f2DfEnJygTL/TkAzDBwTg+JhMxheOUNyPA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.102/dotnet-sdk-10.0.102-linux-musl-arm64.tar.gz";
        hash = "sha512-EL4fPyUW+8EEmtj8sAvRK7sWotIPcIts0Bd82HddAenewQ7B++S1cNfIKxWMt0XXfo7Gb/C59WMnd4Viuhp3vg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.102/dotnet-sdk-10.0.102-linux-musl-x64.tar.gz";
        hash = "sha512-NYbrjeIk11hb9s/SD0ieJ8CiofyMsQfH7ioHvq1Ise2wJB9S/rzw4vn1/fPs488uL5iLFJFmlHRFGJ50BmUszQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.102/dotnet-sdk-10.0.102-osx-arm64.tar.gz";
        hash = "sha512-WtsSpyzP0yf+lM6ZEE7nubVtvkDjVEQKCygxOkmW/zTMhWDWBcHzDCR9NkrkKd5V2MOzDqGdoEpxagWetiuY7Q==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.102/dotnet-sdk-10.0.102-osx-x64.tar.gz";
        hash = "sha512-VCDVyr23qkwOGoWQdHTayHPSDMxb8oEGgPCk0fyd6Ujpt74V80ZPzea+gRyFtM4pDstlhfiSB38Q9A2q7QMkng==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0 = sdk_10_0_1xx;
}
